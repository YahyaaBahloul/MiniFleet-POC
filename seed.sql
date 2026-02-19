-- 1. Création de la Base de Données
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'OptiFleetDB')
BEGIN
    CREATE DATABASE OptiFleetDB;
END
GO

USE OptiFleetDB;
GO

-- 2. Création de la table Véhicules
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Vehicles' and xtype='U')
CREATE TABLE Vehicles (
    Id INT PRIMARY KEY IDENTITY(1,1),
    LicensePlate NVARCHAR(20) NOT NULL UNIQUE, -- Plaque d'immatriculation
    Model NVARCHAR(100) NOT NULL,
    PurchaseDate DATETIME DEFAULT GETDATE(),
    CurrentMileage INT NOT NULL DEFAULT 0 -- Kilométrage actuel
);
GO

-- 3. Création de la table Dépenses 
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Expenses' and xtype='U')
CREATE TABLE Expenses (
    Id INT PRIMARY KEY IDENTITY(1,1),
    VehicleId INT FOREIGN KEY REFERENCES Vehicles(Id) ON DELETE CASCADE,
    ExpenseType NVARCHAR(50) NOT NULL, -- 'Fuel', 'Maintenance', 'Insurance'
    Amount DECIMAL(18, 2) NOT NULL,
    Date DATETIME DEFAULT GETDATE()
);
GO

-- 4. (Seed)
-- Nettoyage préalable pour éviter les doublons lors des tests
TRUNCATE TABLE Expenses;
DELETE FROM Vehicles;

INSERT INTO Vehicles (LicensePlate, Model, PurchaseDate, CurrentMileage) 
VALUES 
('AB-123-CD', 'Peugeot 3008 Hybrid', '2024-01-15', 15000),
('EF-456-GH', 'Renault Megane E-Tech', '2024-02-20', 8500),
('XX-999-ZZ', 'Tesla Model 3', '2023-11-10', 22000);

-- Ajout de dépenses pour le calcul TCO
DECLARE @v1 INT = (SELECT Id FROM Vehicles WHERE LicensePlate = 'AB-123-CD');
DECLARE @v2 INT = (SELECT Id FROM Vehicles WHERE LicensePlate = 'EF-456-GH');

INSERT INTO Expenses (VehicleId, ExpenseType, Amount, Date) VALUES 
(@v1, 'Fuel', 65.50, '2024-02-01'),
(@v1, 'Maintenance', 120.00, '2024-03-01'),
(@v1, 'Insurance', 500.00, '2024-01-16'),
(@v2, 'Electricity', 15.00, '2024-02-25');
GO

-- 5. VUE ANALYTIQUE 
-- Cette vue pré-calcule le TCO et le coût au kilomètre (CPK)
CREATE OR ALTER VIEW View_VehicleTCO AS
SELECT 
    v.Id,
    v.LicensePlate,
    v.Model,
    v.CurrentMileage,
    ISNULL(SUM(e.Amount), 0) as TotalCost,
    -- Calcul du Coût Par Km (CPK) avec sécurité division par zéro
    CAST(
        CASE 
            WHEN v.CurrentMileage > 0 THEN ISNULL(SUM(e.Amount), 0) / v.CurrentMileage 
            ELSE 0 
        END AS DECIMAL(10, 3)
    ) as CostPerKm
FROM Vehicles v
LEFT JOIN Expenses e ON v.Id = e.VehicleId
GROUP BY v.Id, v.LicensePlate, v.Model, v.CurrentMileage;
GO
