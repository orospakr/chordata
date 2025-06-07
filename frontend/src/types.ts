export interface AttributeData {
  name: string;
  type: string;
  optional: boolean;
}

export interface RelationshipData {
  name: string;
  destinationEntity: string;
  toMany: boolean;
  optional: boolean;
}

export interface ObjectInstanceData {
  objectID: string;
  attributeValues: Record<string, string>;
}

export interface ModelData {
  name: string;
  attributeCount: number;
  relationshipCount: number;
  entityCount: number;
  attributes: AttributeData[];
  relationships: RelationshipData[];
  instances: ObjectInstanceData[];
}