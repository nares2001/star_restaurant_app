-- ==============================================================================
-- DATOS INICIALES / SEEDS PARA EL SISTEMA DE RESTAURANTE
-- Totalmente compatibles con `ventaf`, `venta`, `productos` y `star_rest_*`
-- ==============================================================================

SET @CODE_EMP = 'J-00000000-0'; -- Ajustar según DatosEmpresa().rifEmp

-- ------------------------------------------------------------------------------
-- 1. ZONAS DEL RESTAURANTE
-- ------------------------------------------------------------------------------
INSERT INTO `star_rest_zonas` (`code_emp`, `codigo`, `nombre`, `descripcion`, `color_hex`, `orden`, `activo`) VALUES
(@CODE_EMP, 'SALON', 'SALÓN', 'Salón principal con aire acondicionado', '#28A745', 1, '1'),
(@CODE_EMP, 'TERRAZA', 'TERRAZA', 'Área al aire libre y vista exterior', '#0284C7', 2, '1'),
(@CODE_EMP, 'BARRA', 'BARRA', 'Zona de coctelería y servicio rápido', '#EA580C', 3, '1')
ON DUPLICATE KEY UPDATE `nombre` = VALUES(`nombre`), `color_hex` = VALUES(`color_hex`);

-- ------------------------------------------------------------------------------
-- 2. ESTACIONES DE PREPARACIÓN / IMPRESIÓN COMANDA
-- ------------------------------------------------------------------------------
INSERT INTO `star_rest_estaciones` (`code_emp`, `codigo`, `nombre`, `tipo`, `tipo_impresora`, `nombre_impresora`, `ip_impresora`, `puerto_impresora`, `ancho_ticket`, `auto_imprimir`, `activo`) VALUES
(@CODE_EMP, 'COCINA', 'Cocina Caliente', 'cocina', 'termica', 'ImpresoraCocina', '192.168.1.200', '9100', 80, 1, '1'),
(@CODE_EMP, 'BARRA_BEB', 'Barra y Bebidas', 'barra', 'termica', 'ImpresoraBarra', '192.168.1.201', '9100', 80, 1, '1'),
(@CODE_EMP, 'PARRILLA', 'Parrilla y Horno', 'cocina', 'termica', 'ImpresoraParrilla', '192.168.1.202', '9100', 80, 1, '1')
ON DUPLICATE KEY UPDATE `nombre` = VALUES(`nombre`), `tipo` = VALUES(`tipo`);

-- ------------------------------------------------------------------------------
-- 3. PRODUCTOS / PLATOS DEL MENÚ (CATÁLOGO PRODUCTOS)
-- ------------------------------------------------------------------------------
INSERT INTO `productos` (`codigoa`, `detalle1`, `imp`, `price_a`, `price_dolar`, `NomImag`, `code_emp`, `unidad`, `pieza`, `rama`, `ramanomb`) VALUES
('HAM-STAR', 'Hamburguesa Star', 16.00, 12.00, 12.000, 'hamburguesa.jpg', @CODE_EMP, 'UND', 1.00, 'COMIDA', 'Hamburguesas'),
('REF-01',   'Refresco',         16.00, 2.00,  2.000,  'refresco.jpg',    @CODE_EMP, 'UND', 1.00, 'BEBIDA', 'Bebidas'),
('PAP-01',   'Papas Fritas',     16.00, 5.00,  5.000,  'papas.jpg',       @CODE_EMP, 'UND', 1.00, 'COMIDA', 'Entradas'),
('PIZ-01',   'Pizza Margherita', 16.00, 14.50, 14.500, 'pizza.jpg',       @CODE_EMP, 'UND', 1.00, 'COMIDA', 'Pizzas'),
('CER-01',   'Cerveza Polar',    16.00, 3.00,  3.000,  'cerveza.jpg',     @CODE_EMP, 'UND', 1.00, 'BEBIDA', 'Licores')
ON DUPLICATE KEY UPDATE `detalle1` = VALUES(`detalle1`), `price_dolar` = VALUES(`price_dolar`);

-- ------------------------------------------------------------------------------
-- 4. MESAS DEL RESTAURANTE (Basadas en la imagen del diseño)
-- ------------------------------------------------------------------------------
SET @ID_ZONA_SALON = (SELECT id FROM star_rest_zonas WHERE code_emp = @CODE_EMP AND codigo = 'SALON' LIMIT 1);
SET @ID_ZONA_TERRAZA = (SELECT id FROM star_rest_zonas WHERE code_emp = @CODE_EMP AND codigo = 'TERRAZA' LIMIT 1);
SET @ID_ZONA_BARRA = (SELECT id FROM star_rest_zonas WHERE code_emp = @CODE_EMP AND codigo = 'BARRA' LIMIT 1);

-- Mesas de SALÓN
INSERT INTO `star_rest_mesas` (`code_emp`, `id_zona`, `codigo_mesa`, `nombre_mesa`, `capacidad`, `num_sillas`, `forma`, `estado`, `activo`) VALUES
(@CODE_EMP, @ID_ZONA_SALON, 'M1',  'MESA 1',  6, 6, 'rectangular', 'ocupada',    '1'),
(@CODE_EMP, @ID_ZONA_SALON, 'M2',  'MESA 2',  6, 6, 'rectangular', 'ocupada',    '1'),
(@CODE_EMP, @ID_ZONA_SALON, 'M3',  'MESA 3',  6, 6, 'rectangular', 'ocupada',    '1'),
(@CODE_EMP, @ID_ZONA_SALON, 'M4',  'MESA 4',  6, 6, 'rectangular', 'ocupada',    '1'),
(@CODE_EMP, @ID_ZONA_SALON, 'M6',  'MESA 6',  6, 6, 'rectangular', 'disponible', '1'),
(@CODE_EMP, @ID_ZONA_SALON, 'M7',  'MESA 7',  6, 6, 'rectangular', 'ocupada',    '1'),
(@CODE_EMP, @ID_ZONA_SALON, 'M8',  'MESA 8',  6, 6, 'rectangular', 'ocupada',    '1'),
(@CODE_EMP, @ID_ZONA_SALON, 'M9',  'MESA 9',  6, 6, 'rectangular', 'ocupada',    '1'),
(@CODE_EMP, @ID_ZONA_SALON, 'M11', 'MESA 11', 6, 6, 'rectangular', 'disponible', '1'),
(@CODE_EMP, @ID_ZONA_SALON, 'M12', 'MESA 12', 6, 6, 'rectangular', 'disponible', '1'),
(@CODE_EMP, @ID_ZONA_SALON, 'M14', 'MESA 14', 6, 6, 'rectangular', 'disponible', '1'),
(@CODE_EMP, @ID_ZONA_SALON, 'M15', 'MESA 15', 6, 6, 'rectangular', 'disponible', '1')
ON DUPLICATE KEY UPDATE `nombre_mesa` = VALUES(`nombre_mesa`), `estado` = VALUES(`estado`);

-- Mesas de TERRAZA
INSERT INTO `star_rest_mesas` (`code_emp`, `id_zona`, `codigo_mesa`, `nombre_mesa`, `capacidad`, `num_sillas`, `forma`, `estado`, `activo`) VALUES
(@CODE_EMP, @ID_ZONA_TERRAZA, 'T1', 'MESA T-1', 4, 4, 'cuadrada', 'ocupada',    '1'),
(@CODE_EMP, @ID_ZONA_TERRAZA, 'T2', 'MESA T-2', 4, 4, 'cuadrada', 'disponible', '1'),
(@CODE_EMP, @ID_ZONA_TERRAZA, 'T3', 'MESA T-3', 4, 4, 'cuadrada', 'ocupada',    '1'),
(@CODE_EMP, @ID_ZONA_TERRAZA, 'T4', 'MESA T-4', 4, 4, 'cuadrada', 'disponible', '1')
ON DUPLICATE KEY UPDATE `nombre_mesa` = VALUES(`nombre_mesa`), `estado` = VALUES(`estado`);

-- Puestos de BARRA
INSERT INTO `star_rest_mesas` (`code_emp`, `id_zona`, `codigo_mesa`, `nombre_mesa`, `capacidad`, `num_sillas`, `forma`, `estado`, `activo`) VALUES
(@CODE_EMP, @ID_ZONA_BARRA, 'B1', 'BARRA 1', 1, 1, 'barra', 'ocupada',    '1'),
(@CODE_EMP, @ID_ZONA_BARRA, 'B2', 'BARRA 2', 1, 1, 'barra', 'disponible', '1'),
(@CODE_EMP, @ID_ZONA_BARRA, 'B3', 'BARRA 3', 1, 1, 'barra', 'ocupada',    '1'),
(@CODE_EMP, @ID_ZONA_BARRA, 'B4', 'BARRA 4', 1, 1, 'barra', 'disponible', '1')
ON DUPLICATE KEY UPDATE `nombre_mesa` = VALUES(`nombre_mesa`), `estado` = VALUES(`estado`);

-- ------------------------------------------------------------------------------
-- 5. COMANDA ACTIVA EN MESA 1 (REGISTRO EN VENTAF Y VENTA)
-- ------------------------------------------------------------------------------
SET @DOCREG_MESA1 = 'REG-00000001';

-- Insertar cabecera de la comanda en `ventaf`
INSERT INTO `ventaf` (
  `code_emp`, `documento`, `nroMesa`, `numPedido`, `nrodocreg`, `vendedor`, `usuario`, `pos`,
  `fecha`, `total`, `subtotal1`, `dolares`, `valordolares`, `activo`, `nomb`, `rif`
) VALUES (
  @CODE_EMP, 'PEDIDO', 'MESA 1', '1', @DOCREG_MESA1, 'Carlos Perez', 'admin', '1',
  DATE_SUB(NOW(), INTERVAL 2 HOUR + INTERVAL 40 MINUTE), 21.0000, 21.0000, 21.0000, 21.0000, '1', 'CONSUMIDOR FINAL', 'V-00000000-0'
) ON DUPLICATE KEY UPDATE `dolares` = VALUES(`dolares`), `total` = VALUES(`total`);

-- Actualizar enlace en la mesa 1
UPDATE `star_rest_mesas` SET 
  `nrodocreg_actual` = @DOCREG_MESA1,
  `numPedido_actual` = '1',
  `vendedor_actual` = 'Carlos Perez',
  `fecha_apertura` = DATE_SUB(NOW(), INTERVAL 2 HOUR + INTERVAL 40 MINUTE),
  `estado` = 'ocupada'
WHERE `code_emp` = @CODE_EMP AND `nombre_mesa` = 'MESA 1';

-- Insertar los renglones de la comanda en `venta`
INSERT INTO `venta` (
  `code_emp`, `documento`, `nrodocreg`, `codigoa`, `detalle1`, `cantidad`, `precio`, `subtotal`,
  `price_dolar`, `subtotal_dolar`, `fecha`, `vendedor`, `usuario`, `pos`, `activo`
) VALUES 
(@CODE_EMP, 'PEDIDO', @DOCREG_MESA1, 'HAM-STAR', 'Hamburguesa Star', 1.000, 12.0000, 12.0000, 12.000, 12.000, CURDATE(), 'Carlos Perez', 'admin', '1', '1'),
(@CODE_EMP, 'PEDIDO', @DOCREG_MESA1, 'REF-01',   'Refresco',         2.000, 2.0000,  4.0000,  2.000,  4.000,  CURDATE(), 'Carlos Perez', 'admin', '1', '1'),
(@CODE_EMP, 'PEDIDO', @DOCREG_MESA1, 'PAP-01',   'Papas Fritas',     1.000, 5.0000,  5.0000,  5.000,  5.000,  CURDATE(), 'Carlos Perez', 'admin', '1', '1')
ON DUPLICATE KEY UPDATE `subtotal_dolar` = VALUES(`subtotal_dolar`);
