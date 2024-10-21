// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ReprocannDispensary {
    // Roles de usuario
    enum UserRole { None, Patient, Doctor, Admin }

    // Estructura para almacenar información de usuarios
    struct User {
        address userAddress;
        UserRole role;
        bool isApproved;
    }

    // Estructura para solicitudes de dispensa
    struct DispenseRequest {
        uint id;
        address patient;
        bool approvedByDoctor;
        bool fulfilled;
    }

    // Variables de estado
    address public administrator;
    uint public requestCounter = 0;

    mapping(address => User) public users;
    mapping(uint => DispenseRequest) public requests;
    mapping(address => uint[]) public patientRequests;

    // Eventos
    event UserRegistered(address indexed userAddress, UserRole role);
    event UserApproved(address indexed userAddress, UserRole role);
    event DispenseRequestCreated(uint indexed requestId, address indexed patient);
    event DispenseRequestApproved(uint indexed requestId, address indexed doctor);
    event DispenseRequestFulfilled(uint indexed requestId);

    // Modificadores
    modifier onlyAdmin() {
        require(msg.sender == administrator, "Solo el administrador puede realizar esta accion");
        _;
    }

    modifier onlyApprovedUser(UserRole _role) {
        require(users[msg.sender].isApproved, "Usuario no aprobado");
        require(users[msg.sender].role == _role, "Rol de usuario no autorizado");
        _;
    }

    // Constructor
    constructor() {
        administrator = msg.sender;
        users[msg.sender] = User(msg.sender, UserRole.Admin, true);
        emit UserRegistered(msg.sender, UserRole.Admin);
        emit UserApproved(msg.sender, UserRole.Admin);
    }

    // Función para que los usuarios se registren (Paciente o Médico)
    function registerUser(UserRole _role) public {
        require(_role == UserRole.Patient || _role == UserRole.Doctor, "Rol invalido para registro");
        require(users[msg.sender].role == UserRole.None, "Usuario ya registrado");

        users[msg.sender] = User(msg.sender, _role, false);
        emit UserRegistered(msg.sender, _role);
    }

    // Función para que el administrador apruebe usuarios
    function approveUser(address _userAddress) public onlyAdmin {
        require(users[_userAddress].role != UserRole.None, "Usuario no registrado");
        require(!users[_userAddress].isApproved, "Usuario ya aprobado");

        users[_userAddress].isApproved = true;
        emit UserApproved(_userAddress, users[_userAddress].role);
    }

    // Paciente crea una solicitud de dispensa
    function createDispenseRequest() public onlyApprovedUser(UserRole.Patient) {
        requestCounter++;
        requests[requestCounter] = DispenseRequest({
            id: requestCounter,
            patient: msg.sender,
            approvedByDoctor: false,
            fulfilled: false
        });
        patientRequests[msg.sender].push(requestCounter);
        emit DispenseRequestCreated(requestCounter, msg.sender);
    }

    // Médico aprueba una solicitud de dispensa
    function approveDispenseRequest(uint _requestId) public onlyApprovedUser(UserRole.Doctor) {
        DispenseRequest storage dispenseRequest = requests[_requestId];
        require(dispenseRequest.id != 0, "Solicitud no existente");
        require(!dispenseRequest.approvedByDoctor, "Solicitud ya aprobada");
        require(!dispenseRequest.fulfilled, "Solicitud ya cumplida");

        dispenseRequest.approvedByDoctor = true;
        emit DispenseRequestApproved(_requestId, msg.sender);
    }

    // Administrador marca la solicitud como cumplida (auditoría)
    function fulfillDispenseRequest(uint _requestId) public onlyAdmin {
        DispenseRequest storage dispenseRequest = requests[_requestId];
        require(dispenseRequest.id != 0, "Solicitud no existente");
        require(dispenseRequest.approvedByDoctor, "Solicitud no aprobada por un medico");
        require(!dispenseRequest.fulfilled, "Solicitud ya cumplida");

        dispenseRequest.fulfilled = true;
        emit DispenseRequestFulfilled(_requestId);
    }

    // Función para obtener solicitudes de un paciente
    function getPatientRequests(address _patient) public view returns (uint[] memory) {
        return patientRequests[_patient];
    }

    // Función para obtener detalles de una solicitud
    function getDispenseRequest(uint _requestId) public view returns (DispenseRequest memory) {
        return requests[_requestId];
    }
}

