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

app.get('/api/productos', (req, res) => {
  // llamada con filtro http://localhost:3000/api/productos?filtro=Laptop
  filtro = "";
  if (req.params["filtro"]) {
    filtro = req.params["filtro"];
  }
  if (filtro) {
    const productosFiltrados = productos.filter(producto =>
      producto.filtro.toLowerCase().includes(filtro.toLowerCase())
    );
    res.json(productosFiltrados);
  } else {
    res.json(productos);
  }
});

app.post('/api/productos', (req, res) => {
  const nuevoProducto = req.body;
  productos.push(nuevoProducto);
  res.status(201).json(nuevoProducto);
});

app.listen(port, () => {
  console.log(`Servidor corriendo en http://localhost:${port}`);
});
