import { ExpoMapsView, MapColorScheme } from 'expo-maps-remake';
import { View, StyleSheet } from 'react-native';

import { FunctionParameter, useArguments } from '../../components/FunctionDemo';
import Configurator from '../../components/FunctionDemo/Configurator';

const parameters: FunctionParameter[] = [
  {
    name: 'colorScheme',
    type: 'enum',
    values: [
      { name: 'FOLLOW_SYSTEM', value: MapColorScheme.FOLLOW_SYSTEM },
      { name: 'LIGHT', value: MapColorScheme.LIGHT },
      { name: 'DARK', value: MapColorScheme.DARK },
    ],
  },
  {
    name: 'compassEnabled',
    type: 'boolean',
    initial: true,
  },
  {
    name: 'indoorLevelPickerEnabled',
    type: 'boolean',
    initial: true,
  },
  {
    name: 'mapToolbarEnabled',
    type: 'boolean',
    initial: true,
  },
  {
    name: 'myLocationButtonEnabled',
    type: 'boolean',
    initial: true,
  },
  {
    name: 'rotationGesturesEnabled',
    type: 'boolean',
    initial: true,
  },
  {
    name: 'scrollGesturesEnabled',
    type: 'boolean',
    initial: true,
  },
  {
    name: 'scrollGesturesEnabledDuringRotateOrZoom',
    type: 'boolean',
    initial: true,
  },
  {
    name: 'tiltGesturesEnabled',
    type: 'boolean',
    initial: true,
  },
  {
    name: 'zoomControlsEnabled',
    type: 'boolean',
    initial: true,
  },
  {
    name: 'zoomGesturesEnabled',
    type: 'boolean',
    initial: true,
  },
];

export default function MapsUISettings() {
  const [args, updateArgument] = useArguments(parameters);
  const [
    colorScheme,
    compassEnabled,
    indoorLevelPickerEnabled,
    mapToolbarEnabled,
    myLocationButtonEnabled,
    rotationGesturesEnabled,
    scrollGesturesEnabled,
    scrollGesturesEnabledDuringRotateOrZoom,
    tiltGesturesEnabled,
    zoomControlsEnabled,
    zoomGesturesEnabled,
  ] = args as [
    MapColorScheme,
    boolean,
    boolean,
    boolean,
    boolean,
    boolean,
    boolean,
    boolean,
    boolean,
    boolean,
    boolean,
  ];
  return (
    <View style={styles.container}>
      <View style={styles.container}>
        <ExpoMapsView
          style={{ width: 'auto', height: '100%' }}
          cameraPosition={{
            coordinates: {
              latitude: 37.78825,
              longitude: -122.4324,
            },
            zoom: 8,
          }}
          colorScheme={colorScheme}
          uiSettings={{
            compassEnabled,
            indoorLevelPickerEnabled,
            mapToolbarEnabled,
            myLocationButtonEnabled,
            rotationGesturesEnabled,
            scrollGesturesEnabled,
            scrollGesturesEnabledDuringRotateOrZoom,
            tiltGesturesEnabled,
            zoomControlsEnabled,
            zoomGesturesEnabled,
          }}
        />
      </View>

      <View style={styles.configurator}>
        <Configurator parameters={parameters} onChange={updateArgument} value={args} />
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  configurator: {
    paddingHorizontal: 15,
  },
});
