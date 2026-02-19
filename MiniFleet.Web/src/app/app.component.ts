import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { HttpClient } from '@angular/common/http';

// interface TypeScript qui correspond exactement au DTO C# 
interface VehicleTco {
  licensePlate: string;
  model: string;
  currentMileage: number;
  totalCost: number;
  costPerKm: number;
}

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './app.component.html',
  styleUrl: './app.component.css'
})
export class AppComponent implements OnInit {
  title = 'Tableau de Bord TCO - WinFlotte POC';
  http = inject(HttpClient);
  vehicles: VehicleTco[] = [];

  ngOnInit() {
    // On appelle notre API C# sur le port 5050 !
    this.http.get<VehicleTco[]>('http://localhost:5050/api/vehicles/tco')
      .subscribe({
        next: (data) => {
          this.vehicles = data;
          console.log('Données reçues :', data);
        },
        error: (err) => console.error('Erreur de connexion à l\'API', err)
      });
  }
}