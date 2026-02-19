using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MiniFleet.API.Data;
using MiniFleet.API.Models;

namespace MiniFleet.API.Controllers
{
    [Route("api/[controller]")] // L'URL sera: api/vehicles
    [ApiController]
    public class VehiclesController : ControllerBase
    {
        private readonly AppDbContext _context;

        // Le constructeur (Injection de dépendance pour récupérer la base de données)
        public VehiclesController(AppDbContext context)
        {
            _context = context;
        }

        // GET: api/vehicles/tco
        [HttpGet("tco")]
        public async Task<ActionResult<IEnumerable<VehicleTcoDto>>> GetTcoReport()
        {
            // C'est ici que tu prouves ta maîtrise de C# 8 et SQL !
            // On exécute ta vue SQL directement et on mappe le résultat dans notre DTO.
            var report = await _context.Database
                .SqlQuery<VehicleTcoDto>($"SELECT * FROM View_VehicleTCO")
                .ToListAsync();

            return Ok(report);
        }
    }
}