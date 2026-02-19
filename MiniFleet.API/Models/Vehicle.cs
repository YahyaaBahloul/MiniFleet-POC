namespace MiniFleet.API.Models
{
    public class Vehicle
    {
        public int Id { get; set; }
        public required string LicensePlate { get; set; }
        public required string Model { get; set; }
        public DateTime PurchaseDate { get; set; }
        public int CurrentMileage { get; set; }
    }
}