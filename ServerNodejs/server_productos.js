//server.js

const express = require('express');
const app = express();
const port = 3000;

const productos = [
  {
    id: '1',
    id2: '1001',
    grp1: 'Electrónica',
    grp2: 'Computadoras',
    grp3: 'Laptops',
    grp4: 'Gaming',
    descripcion: 'Laptop Gamer XYZ',
    tdhr: '2023-04-05T08:30:00',
  },
  {
    id: '2',
    id2: '1002',
    grp1: 'Electrónica',
    grp2: 'Computadoras',
    grp3: 'Laptops',
    grp4: 'Ultrabook',
    descripcion: 'Ultrabook ABC',
    tdhr: '2023-04-05T10:45:00',
  },
  {
    id: '3',
    id2: '2001',
    grp1: 'Hogar',
    grp2: 'Cocina',
    grp3: 'Utensilios',
    grp4: 'Cuchillos',
    descripcion: 'Set de cuchillos de cocina',
    tdhr: '2023-04-05T14:20:00',
  },
];

stocks = [{
  "idStock": "100",
  "id": "1",
  "id2": "ID2-1",
  "ubicacion": "Almacen A",
  "cantidad": 100.0,
  "unidadMedida": "Kg",
  "unidadesEmbalaje": 10,
  "tipoEmbalaje": "Caja",
  "idSerialLote": "Lote-123",
  "tdhrCaduca": "2023-09-01",
  "tdhr": "2023-04-01"
}, {
  "idStock": "101",
  "id": "2",
  "id2": "ID2-2",
  "ubicacion": "Almacen B",
  "cantidad": 250.0,
  "unidadMedida": "L",
  "unidadesEmbalaje": 5,
  "tipoEmbalaje": "Bidon",
  "idSerialLote": "Lote-456",
  "tdhrCaduca": "2023-08-15",
  "tdhr": "2023-03-15"
}, {
  "idStock": "102",
  "id": "3",
  "id2": "ID2-3",
  "ubicacion": "Almacen C",
  "cantidad": 50.0,
  "unidadMedida": "Unidad",
  "unidadesEmbalaje": 25,
  "tipoEmbalaje": "Paquete",
  "idSerialLote": "Lote-789",
  "tdhrCaduca": "2023-07-30",
  "tdhr": "2023-02-28"
  }, {
    "idStock": "103",
    "id": "1",
    "id2": "ID2-3",
    "ubicacion": "Almacen C",
    "cantidad": 50.0,
    "unidadMedida": "Unidad",
    "unidadesEmbalaje": 25,
    "tipoEmbalaje": "Paquete",
    "idSerialLote": "Lote1-789",
    "tdhrCaduca": "2023-07-30",
    "tdhr": "2023-02-28"
  }, {
    "idStock": "104",
    "id": "2",
    "id2": "ID2-3",
    "ubicacion": "Almacen C",
    "cantidad": 50.0,
    "unidadMedida": "Unidad",
    "unidadesEmbalaje": 25,
    "tipoEmbalaje": "Paquete",
    "idSerialLote": "Lote1-789",
    "tdhrCaduca": "2023-07-30",
    "tdhr": "2023-02-28"
  }, {
    "idStock": "105",
    "id": "3",
    "id2": "ID2-3",
    "ubicacion": "Almacen C",
    "cantidad": 50.0,
    "unidadMedida": "Unidad",
    "unidadesEmbalaje": 25,
    "tipoEmbalaje": "Paquete",
    "idSerialLote": "Lote1-789",
    "tdhrCaduca": "2023-07-30",
    "tdhr": "2023-02-28"
  }, {
    "idStock": "106",
    "id": "1",
    "id2": "ID2-1",
    "ubicacion": "Almacen A",
    "cantidad": 100.0,
    "unidadMedida": "Kg",
    "unidadesEmbalaje": 10,
    "tipoEmbalaje": "Caja",
    "idSerialLote": "Lote2-123",
    "tdhrCaduca": "2023-09-01",
    "tdhr": "2023-04-01"
  }, {
    "idStock": "107",
    "id": "2",
    "id2": "ID2-2",
    "ubicacion": "Almacen B",
    "cantidad": 250.0,
    "unidadMedida": "L",
    "unidadesEmbalaje": 5,
    "tipoEmbalaje": "Bidon",
    "idSerialLote": "Lote2-456",
    "tdhrCaduca": "2023-08-15",
    "tdhr": "2023-03-15"
  }, {
    "idStock": "108",
    "id": "3",
    "id2": "ID2-3",
    "ubicacion": "Almacen C",
    "cantidad": 50.0,
    "unidadMedida": "Unidad",
    "unidadesEmbalaje": 25,
    "tipoEmbalaje": "Paquete",
    "idSerialLote": "Lote2-789",
    "tdhrCaduca": "2023-07-30",
    "tdhr": "2023-02-28"
  }, {
    "idStock": "109",
    "id": "1",
    "id2": "ID2-3",
    "ubicacion": "Almacen C",
    "cantidad": 50.0,
    "unidadMedida": "Unidad",
    "unidadesEmbalaje": 25,
    "tipoEmbalaje": "Paquete",
    "idSerialLote": "Lote3-789",
    "tdhrCaduca": "2023-07-30",
    "tdhr": "2023-02-28"
  }, {
    "idStock": "110",
    "id": "2",
    "id2": "ID2-3",
    "ubicacion": "Almacen C",
    "cantidad": 50.0,
    "unidadMedida": "Unidad",
    "unidadesEmbalaje": 25,
    "tipoEmbalaje": "Paquete",
    "idSerialLote": "Lote3-789",
    "tdhrCaduca": "2023-07-30",
    "tdhr": "2023-02-28"
  }, {
    "idStock": "111",
    "id": "3",
    "id2": "ID2-3",
    "ubicacion": "Almacen C",
    "cantidad": 50.0,
    "unidadMedida": "Unidad",
    "unidadesEmbalaje": 25,
    "tipoEmbalaje": "Paquete",
    "idSerialLote": "Lote3-789",
    "tdhrCaduca": "2023-07-30",
    "tdhr": "2023-02-28"
  }
];


app.get('/api/productos', (req, res) => {
  // llamada con filtro http://localhost:3000/api/productos?filtro=Laptop
  filtro = "";
  if (req.params["filtro"]) {
    filtro = req.params["filtro"];
  }
  console.log("productos")
  if (filtro) {
    const productosFiltrados = productos.filter(producto =>
      producto.filtro.toLowerCase().includes(filtro.toLowerCase())
    );
    res.json(productosFiltrados);
  } else {
    res.json(productos);
  }
});

app.get('/api/stocks', (req, res) => {
  // llamada con filtro http://localhost:3000/api/productos?filtro=Laptop
  filtro = "";
  if (req.params["filtro"]) {
    filtro = req.params["filtro"];
  }
  console.log("stocks")
  if (filtro) {
    const stocksFiltrados = stocks.filter(stocks =>
      stocks.filtro.toLowerCase().includes(filtro.toLowerCase())
    );
    res.json(stocksFiltrados);
  } else {
    res.json(stocks);
  }
});

app.post('/api/productos', (req, res) => {
  const nuevoProducto = req.body;
  productos.push(nuevoProducto);
  res.status(201).json(nuevoProducto);
});

app.post('/api/stocks', (req, res) => {
  const nuevostocks = req.body;
  productos.push(nuevostocks);
  res.status(201).json(nuevostocks);
});

app.listen(port, () => {
  console.log(`Servidor corriendo en http://localhost:${port}`);
});
