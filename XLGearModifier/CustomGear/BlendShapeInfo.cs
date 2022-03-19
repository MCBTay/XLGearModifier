namespace XLGearModifier.CustomGear
{
    public class BlendShapeInfo
    {
        public string Name;

        public int Index;

        public float Minimum;
        public float Maximum;

        public float Weight;

        public BlendShapeInfo(int index, string name, float weight)
        {
            Index = index;
            Name = name;
            Minimum = 0;
            Maximum = 100;
            Weight = weight;
        }
    }
}
