using System;
using System.Collections.Generic;
using UnityEngine;
using XLGearModifier.Unity.Attributes;

namespace XLGearModifier.Unity
{
    [Serializable]
    public class XLGMBlendShapeController : MonoBehaviour
    {
        [ReadOnly] 
        public SkinnedMeshRenderer SkinnedMeshRenderer;

        [ReadOnly] 
        public Mesh SkinnedMesh;

        [ReadOnly] 
        public List<XLGMBlendShapeData> BlendShapes;

        public void Start()
        {
            BlendShapes = new List<XLGMBlendShapeData>();
        }

        public void GetBlendShapeData(GameObject gameObject)
        {
            if (gameObject == null) return;

            SkinnedMeshRenderer = gameObject.GetComponentInChildren<SkinnedMeshRenderer>();
            if (SkinnedMeshRenderer == null) return;

            SkinnedMesh = SkinnedMeshRenderer.sharedMesh;
            if (SkinnedMesh == null) return;

            BlendShapes.Clear();

            for (int i = 0; i < SkinnedMesh.blendShapeCount; i++)
            {
                BlendShapes.Add(new XLGMBlendShapeData
                {
                    index = i,
                    name = SkinnedMesh.GetBlendShapeName(i),
                    weight = SkinnedMeshRenderer.GetBlendShapeWeight(i)
                });
            }
        }

        public void ClearBlendShapeData()
        {
            SkinnedMeshRenderer = null;
            SkinnedMesh = null;
            BlendShapes.Clear();
        }
    }
}
