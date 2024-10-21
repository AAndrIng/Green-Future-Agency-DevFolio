# ReprocannDispensary Smart Contract

## Descripción
ReprocannDispensary es un smart contract desarrollado para gestionar un sistema de dispensario de cannabis medicinal. El contrato maneja roles de usuarios, solicitudes de dispensación y aprobaciones médicas.

## Características
- Gestión de roles: Paciente, Doctor, Administrador
- Registro y aprobación de usuarios
- Creación y gestión de solicitudes de dispensación
- Aprobación médica de solicitudes
- Cumplimiento de solicitudes (auditoría)

## Requisitos
- Solidity ^0.8.0
- Truffle Suite (recomendado para desarrollo y pruebas)
- Node.js y npm

## Instalación
1. Clonar el repositorio:
   ```
   git clone https://github.com/your-username/reprocann-dispensary.git
   cd reprocann-dispensary
   ```

2. Instalar dependencias (si usas Truffle):
   ```
   npm install
   ```

## Despliegue
1. Configurar el archivo de migración en `migrations/` (si usas Truffle)
2. Ejecutar la migración:
   ```
   truffle migrate --network <your-network>
   ```

## Uso
El contrato permite las siguientes operaciones principales:

1. Registro de usuarios:
   ```solidity
   function registerUser(UserRole _role) public
   ```

2. Aprobación de usuarios:
   ```solidity
   function approveUser(address _userAddress) public onlyAdmin
   ```

3. Creación de solicitud de dispensación:
   ```solidity
   function createDispenseRequest() public onlyApprovedUser(UserRole.Patient)
   ```

4. Aprobación de solicitud por médico:
   ```solidity
   function approveDispenseRequest(uint _requestId) public onlyApprovedUser(UserRole.Doctor)
   ```

5. Cumplimiento de solicitud:
   ```solidity
   function fulfillDispenseRequest(uint _requestId) public onlyAdmin
   ```

## Pruebas
(Añadir instrucciones para ejecutar las pruebas una vez que se hayan implementado)

## Contribución
Las contribuciones son bienvenidas. Por favor, abre un issue para discutir cambios mayores antes de crear un pull request.

## Licencia
Este proyecto está licenciado bajo MIT License y la Ley Nacional del Derecho de Autor de la Republica Argentina.

## Versión
v0.1.0

## Próximas Características
- Implementación de frontend
- Integración con sistemas de inventario
- Mejoras en la seguridad y auditoría

## Contacto
Para más información, contacta a [greenfutureagency] en [hnasar@gmail.com].
