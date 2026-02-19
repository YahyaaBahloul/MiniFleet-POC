using Microsoft.EntityFrameworkCore;
using MiniFleet.API.Models;

namespace MiniFleet.API.Data
{
    public class AppDbContext : DbContext
    {
        // Le constructeur qui permet de passer les options de configuration
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

        // on fait le lien entre la classe Vehicle et la table Vehicles de la base de données
        public DbSet<Vehicle> Vehicles { get; set; }
    }
}