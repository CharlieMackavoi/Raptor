SEntitySpawnParams params;
params.sName = "TestEntity";
params.sLayerName = "TestLayer";
params.nFlags = ENTITY_FLAG_NO_SAVE | ENTITY_FLAG_SPAWNED;
params.pClass = gEnv->pEntitySystem->GetClassRegistry()->GetDefaultClass();
params.vScale = testScale;
params.vPosition = testPos;
e1 = gEnv->pEntitySystem->SpawnEntity(params, true);

if (e1 != NULL)
{
   // Pick a default material
   IMaterial *pMat = gEnv->p3DEngine->GetMaterialManager()->LoadMaterial("material_default");
   e1->SetMaterial(pMat);

   // Load some simple test geometry
   int slotId = e1->LoadGeometry(0, "objects/default/primitive_cylinder.cgf");
}
