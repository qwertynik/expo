@file:Suppress("DEPRECATION")

package expo.modules.rncompatibility

import com.facebook.react.config.ReactFeatureFlags

interface IReactNativeFeatureFlagsProvider {
  val enableBridgelessArchitecture: Boolean
}

/**
 * A compatibility helper of
 * `com.facebook.react.config.ReactFeatureFlags` and
 * `com.facebook.react.internal.featureflags.ReactNativeFeatureFlags`
 */
object ReactNativeFeatureFlags : IReactNativeFeatureFlagsProvider {
  val enableBridgelessArchitecture = ReactFeatureFlags.enableBridgelessArchitecture
}
