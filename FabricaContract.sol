// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract FabricaContract {
    uint _idDigits = 16;

    struct Producto{
        string nombre;
        uint id;
    }

    Producto[] public productos;

    function _crearProducto (string memory _nombre, uint _id) private{
        productos.push(Producto(_nombre,_id));
        emit NuevoProducto(productos.length - 1, _nombre, _id);
    }

    function _generarIdAleatorio (string memory _str) private view returns (uint) {
        uint _rand = uint(keccak256(abi.encodePacked(_str)));
        uint _idModulus = 10^_idDigits;

        return _rand % _idModulus;
    } 

    function _crearProductoAleatorio (string memory _nombre) public { 
        uint _randID = _generarIdAleatorio(_nombre);
        _crearProducto(_nombre, _randID);
    }

    event NuevoProducto (uint _ArrayProductoId, string _nombre, uint _id);

    mapping (address => uint)  public _propietarioProductos;
    mapping (uint => address)  public _productoAPropietario;

    function _Propiedad(uint _productoId) public  {
        _productoAPropietario[_productoId] = msg.sender;
        _propietarioProductos[msg.sender]++;
    }

    function _getProductosPorPropietario (address _propietario) external view returns(uint[] memory) {
        uint _contador = 0;
        uint n = _propietarioProductos[_propietario];
        uint[] memory resultado = new uint[](n);

        for (uint i=0; i<productos.length; i++){
            uint foundId = productos[i].id;
            if (_productoAPropietario[foundId] == _propietario){
                resultado[_contador] = foundId;
                _contador++;
            }
        }
        return resultado;
    }

}