namespace MiniFleet.API.Models
{
    // Cette classe représente la ligne de résultat de ta requête SQL d'analyse
    public class VehicleTcoDto
    {
        public required string LicensePlate { get; set; }
        public required string Model { get; set; }
        public int CurrentMileage { get; set; }
        public decimal TotalCost { get; set; }
        public decimal CostPerKm { get; set; }
    }
}