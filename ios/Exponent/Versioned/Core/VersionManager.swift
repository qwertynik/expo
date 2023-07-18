// Copyright 2023-present 650 Industries. All rights reserved.

import React
import ExpoModulesCore
import EXManifests

@objc(EXVersionManager)
final class VersionManager: EXVersionManagerObjC {
  let appContext: AppContext

  let params: [AnyHashable: Any]

  let manifest: Manifest

  let legacyModulesProxy: LegacyNativeModulesProxy

  let legacyModuleRegistry: EXModuleRegistry

  /**
   * Uses a params dict since the internal workings may change over time, but we want to keep the interface the same.
   *  Expected params:
   *    NSDictionary *constants
   *    NSURL *initialUri
   *    @BOOL isDeveloper
   *    @BOOL isStandardDevMenuAllowed
   *    @EXTestEnvironment testEnvironment
   *    NSDictionary *services
   *
   * Kernel-only:
   *    EXKernel *kernel
   *    NSArray *supportedSdkVersions
   *    id exceptionsManagerDelegate
   */
  @objc
  public override init(
    params: [AnyHashable: Any],
    manifest: Manifest,
    fatalHandler: @escaping (Error?) -> Void,
    logFunction: @escaping RCTLogFunction,
    logThreshold: RCTLogLevel
  ) {
    self.params = params
    self.manifest = manifest

    configureReact(
      enableTurboModules: manifest.experiments()?["turboModules"] as? Bool ?? false,
      fatalHandler: fatalHandler,
      logFunction: logFunction,
      logThreshold: logThreshold
    )

    legacyModuleRegistry = createLegacyModuleRegistry(params: params, manifest: manifest)
    legacyModulesProxy = LegacyNativeModulesProxy(customModuleRegistry: legacyModuleRegistry)
    appContext = AppContext(legacyModulesProxy: legacyModulesProxy, legacyModuleRegistry: legacyModuleRegistry)

    super.init(params: params, manifest: manifest, fatalHandler: fatalHandler, logFunction: logFunction, logThreshold: logThreshold)

    registerExpoModules()
  }

  override func invalidate() {
    appContext._runtime = nil
    super.invalidate()
  }

  @objc
  override func extraModules(forBridge bridge: Any!) -> [Any]! {
    var modules: [Any] = [
      EXAppState(),
      EXDisabledDevLoadingView(),
      EXStatusBarManager(),

      // Adding EXNativeModulesProxy with the custom moduleRegistry.
      legacyModulesProxy,

      // Adding the way to access the module registry from RCTBridgeModules.
      EXModuleRegistryHolderReactModule(moduleRegistry: legacyModuleRegistry) as Any,

      // When ExpoBridgeModule is initialized by RN, it automatically creates the app context.
      // In Expo Go, it has to use already created app context.
      ExpoBridgeModule(appContext: appContext)
    ]
    return modules + super.extraModules(forBridge: bridge)
  }

  // MARK: - private

  private func registerExpoModules() {
    appContext.useModulesProvider("ExpoModulesProvider")
    appContext.moduleRegistry.register(moduleType: ExpoGoModule.self)
  }
}

private func configureReact(
  enableTurboModules: Bool,
  fatalHandler: @escaping (Error?) -> Void,
  logFunction: @escaping RCTLogFunction,
  logThreshold: RCTLogLevel
) {
  RCTEnableTurboModule(enableTurboModules)
  RCTSetFatalHandler(fatalHandler)
  RCTSetLogThreshold(logThreshold)
  RCTSetLogFunction(logFunction)
}

private func createLegacyModuleRegistry(params: [AnyHashable: Any], manifest: Manifest) -> EXModuleRegistry {
  let moduleRegistryProvider = ModuleRegistryProvider(singletonModules: params["singletonModules"] as! Set<AnyHashable>)
  let moduleRegistryAdapter = EXScopedModuleRegistryAdapter(moduleRegistryProvider: moduleRegistryProvider);

  moduleRegistryProvider.moduleRegistryDelegate = EXScopedModuleRegistryDelegate(params: params)

  return moduleRegistryAdapter.moduleRegistry(
    forParams: params,
    forExperienceStableLegacyId: manifest.stableLegacyId(),
    scopeKey: manifest.scopeKey(),
    manifest: manifest,
    withKernelServices: params["services"] as? [AnyHashable : Any]
  )
}
