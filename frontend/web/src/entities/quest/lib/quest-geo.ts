export type Coordinates = {
  lat: number;
  lng: number;
};

const EKB_CENTER: Coordinates = { lat: 56.8389, lng: 60.6057 };

export function getDefaultMapCenter(): Coordinates {
  return EKB_CENTER;
}

export function questCoordinates(quest: {
  latitude: number;
  longitude: number;
}): Coordinates {
  return { lat: quest.latitude, lng: quest.longitude };
}
