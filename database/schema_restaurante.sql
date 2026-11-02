-- ==============================================================================
-- SISTEMA DE RESTAURANTE - STARSYSTEM
-- INTEGRACIÓN NATIVA CON TABLAS DE FACTURACIÓN E INVENTARIO:
-- `ventaf` (Cabecera / ModeloFactura)
-- `venta`  (Detalle  / ModeloVentaProducto)
-- `productos` (Catálogo / ModeloProductoVenta)
-- Y TABLAS DE RESTAURANTE: `star_rest_mesas`, `star_rest_zonas`, `star_rest_estaciones`
-- MULTI-EMPRESA: Todos los registros vinculados por `code_emp` VARCHAR(15)
-- Motor: InnoDB | Cotejamiento: utf8mb4_general_ci
-- ==============================================================================

-- ------------------------------------------------------------------------------
-- 1. TABLA: PRODUCTOS (CATÁLOGO DE INVENTARIO Y PLATOS)
--    Mapea directamente con `ModeloProductoVenta`
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `productos` (
	`codigoa` VARCHAR(25) NOT NULL COLLATE 'utf8mb4_general_ci',
	`codigob` VARCHAR(25) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`detalle1` VARCHAR(80) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`detalle2` VARCHAR(80) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`rama` VARCHAR(15) NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`ramanomb` VARCHAR(50) NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`unidad` VARCHAR(20) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`imp` DECIMAL(11,2) NULL DEFAULT '0.00',
	`gain_a` DECIMAL(20,4) NULL DEFAULT '0.0000',
	`price_a` DECIMAL(20,4) NULL DEFAULT '0.0000',
	`gain_b` DECIMAL(20,4) NULL DEFAULT '0.0000',
	`price_b` DECIMAL(20,4) NULL DEFAULT '0.0000',
	`gain_c` DECIMAL(20,4) NULL DEFAULT '0.0000',
	`price_c` DECIMAL(20,4) NULL DEFAULT '0.0000',
	`gain_d` DECIMAL(20,4) NULL DEFAULT '0.0000',
	`price_d` DECIMAL(20,4) NULL DEFAULT '0.0000',
	`costo_a` DECIMAL(20,4) NULL DEFAULT '0.0000',
	`costo_p` DECIMAL(20,4) NULL DEFAULT '0.0000',
	`costo_u` DECIMAL(20,4) NULL DEFAULT '0.0000',
	`date_c` DATE NULL DEFAULT NULL,
	`date_v` DATE NULL DEFAULT NULL,
	`date_i` DATE NULL DEFAULT NULL,
	`existence_p` DECIMAL(11,3) NULL DEFAULT '0.000',
	`marca` VARCHAR(50) NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`tipo` VARCHAR(50) NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`peso` VARCHAR(50) NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`fracc` VARCHAR(20) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`creado` VARCHAR(20) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`serial` VARCHAR(20) NULL DEFAULT 'No' COLLATE 'utf8mb4_general_ci',
	`code_emp` VARCHAR(15) NOT NULL COLLATE 'utf8mb4_general_ci',
	`preciofact` VARCHAR(20) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`priceb_a` DECIMAL(20,4) NULL DEFAULT '0.0000',
	`priceb_b` DECIMAL(20,4) NULL DEFAULT '0.0000',
	`priceb_c` DECIMAL(20,4) NULL DEFAULT '0.0000',
	`priceb_d` DECIMAL(20,4) NULL DEFAULT '0.0000',
	`pieza` DECIMAL(11,2) NULL DEFAULT '1.00',
	`grado` VARCHAR(20) NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`origen` VARCHAR(20) NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`instituto` VARCHAR(20) NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`posact` VARCHAR(30) NULL DEFAULT '00000000000000000000' COLLATE 'utf8mb4_general_ci',
	`costo_r` DECIMAL(20,4) NULL DEFAULT '0.0000',
	`gainr_a` DECIMAL(20,4) NULL DEFAULT '0.0000',
	`gainr_b` DECIMAL(20,4) NULL DEFAULT '0.0000',
	`gainr_c` DECIMAL(20,4) NULL DEFAULT '0.0000',
	`gainr_d` DECIMAL(20,4) NULL DEFAULT '0.0000',
	`ubicacion` VARCHAR(50) NULL DEFAULT '0' COLLATE 'utf8mb4_general_ci',
	`date_a` DATETIME NULL DEFAULT '2013-01-01 12:00:00',
	`invfisico` DECIMAL(20,3) NULL DEFAULT '0.000',
	`invantes` DECIMAL(20,3) NULL DEFAULT '0.000',
	`diferencia` DECIMAL(20,3) NULL DEFAULT '0.000',
	`descuentoc` DECIMAL(20,2) NULL DEFAULT '0.00',
	`recargoc` DECIMAL(20,2) NULL DEFAULT '0.00',
	`bloquear` DECIMAL(20,3) NULL DEFAULT '0.000',
	`dias` INT NULL DEFAULT '0',
	`pcosto_op` DECIMAL(20,4) NULL DEFAULT '0.0000',
	`costo_op` DECIMAL(20,4) NULL DEFAULT '0.0000',
	`subgrupo` VARCHAR(50) NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`factespera` DECIMAL(20,3) NULL DEFAULT '0.000',
	`ultconteo` DECIMAL(20,3) NULL DEFAULT '0.000',
	`pesoequiv` DECIMAL(11,3) NULL DEFAULT '0.000',
	`comision` VARCHAR(20) NULL DEFAULT 'Ninguna' COLLATE 'utf8mb4_general_ci',
	`costo_dolar` DECIMAL(14,3) NULL DEFAULT '0.000',
	`costo_cop` DECIMAL(14,3) NULL DEFAULT '0.000',
	`price_dolar` DECIMAL(14,3) NULL DEFAULT '0.000',
	`price_cop` DECIMAL(14,3) NULL DEFAULT '0.000',
	`calculoautomatico` INT NULL DEFAULT '1',
	`Price_dolar_b` DECIMAL(16,3) NULL DEFAULT '0.000',
	`Price_dolar_c` DECIMAL(16,3) NULL DEFAULT '0.000',
	`Price_dolar_d` DECIMAL(16,3) NULL DEFAULT '0.000',
	`Price_Cop_b` DECIMAL(16,3) NULL DEFAULT '0.000',
	`Price_Cop_c` DECIMAL(16,3) NULL DEFAULT '0.000',
	`Price_Cop_d` DECIMAL(16,3) NULL DEFAULT '0.000',
	`existence_dep` DECIMAL(11,3) NULL DEFAULT '0.000',
	`updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`NomImag` VARCHAR(100) NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	PRIMARY KEY (`codigoa`, `code_emp`) USING BTREE,
	INDEX `idx_reporte_inventario` (`code_emp`, `existence_p`) USING BTREE,
	INDEX `idx_sync_key` (`code_emp`, `codigoa`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- ------------------------------------------------------------------------------
-- 2. TABLA: VENTAF (CABECERA DE FACTURA Y COMANDA/PEDIDO DE MESA)
--    Mapea directamente con `ModeloFactura`
--    - Para mesas abiertas: documento = 'PEDIDO', nroMesa = 'MESA 1', activo = '1'
--    - Para facturadas: documento = 'FAC', activo = '1'
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ventaf` (
	`id` INT NOT NULL AUTO_INCREMENT,
	`fecha` DATETIME NULL DEFAULT NULL,
	`rif` VARCHAR(15) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`nomb` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`documento` VARCHAR(30) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`numgeneral` VARCHAR(20) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`numcontrol` VARCHAR(20) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`fechageneral` DATE NULL DEFAULT NULL,
	`fechadecl` DATE NULL DEFAULT NULL,
	`numFAC` VARCHAR(20) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`numNC` VARCHAR(20) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`numND` VARCHAR(20) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`numafect` VARCHAR(20) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`numafectND` VARCHAR(20) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`fechaafect` DATE NULL DEFAULT NULL,
	`nrofiscal` VARCHAR(20) NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`nrodocreg` VARCHAR(20) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`tipo` VARCHAR(20) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`total` DECIMAL(20,4) NULL DEFAULT '0.0000',
	`exento` DECIMAL(20,4) NULL DEFAULT '0.0000',
	`subtotal1` DECIMAL(20,4) NULL DEFAULT '0.0000',
	`impuesto1` DECIMAL(20,4) NULL DEFAULT '0.0000',
	`subtotal2` DECIMAL(20,4) NULL DEFAULT '0.0000',
	`impuesto2` DECIMAL(20,4) NULL DEFAULT '0.0000',
	`subtotal3` DECIMAL(20,4) NULL DEFAULT '0.0000',
	`impuesto3` DECIMAL(20,4) NULL DEFAULT '0.0000',
	`subtotal4` DECIMAL(20,4) NULL DEFAULT '0.0000',
	`impuesto4` DECIMAL(20,4) NULL DEFAULT '0.0000',
	`activo` VARCHAR(20) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`vendedor` VARCHAR(20) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`efectivo` DECIMAL(20,4) NULL DEFAULT '0.0000',
	`transvarias` DECIMAL(20,4) NULL DEFAULT '0.0000',
	`tickets` DECIMAL(20,4) NULL DEFAULT '0.0000',
	`credito` DECIMAL(20,4) NULL DEFAULT '0.0000',
	`historico` VARCHAR(20) NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`contri` VARCHAR(20) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`usuario` VARCHAR(20) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`pos` VARCHAR(10) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`nrozeta` VARCHAR(10) NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`maquinanro` VARCHAR(15) NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`code_emp` VARCHAR(15) NOT NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`excedente` DECIMAL(20,4) NULL DEFAULT '0.0000',
	`dir1` VARCHAR(300) NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`horaNC` VARCHAR(15) NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`observacioncli` VARCHAR(300) NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`server` VARCHAR(30) NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`ntarjeta` VARCHAR(20) NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`nvendedor` VARCHAR(100) NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`transportista` VARCHAR(100) NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`vehiculo` VARCHAR(50) NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`conductor` VARCHAR(100) NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`placa` VARCHAR(15) NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`citransp` VARCHAR(20) NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`licenlic` VARCHAR(20) NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`fechavence` DATE NULL DEFAULT NULL,
	`dias` INT NULL DEFAULT '0',
	`porcecomi` DECIMAL(20,4) NULL DEFAULT '0.0000',
	`tipocomi` VARCHAR(100) NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`comision` DECIMAL(20,4) NULL DEFAULT '0.0000',
	`estatuscomi` VARCHAR(100) NULL DEFAULT 'Pendiente' COLLATE 'utf8mb4_general_ci',
	`planillacomi` VARCHAR(10) NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`fechaenvio` DATE NULL DEFAULT NULL,
	`guiadespacho` VARCHAR(20) NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`valordolares` DECIMAL(20,4) NULL DEFAULT '0.0000',
	`dolares` DECIMAL(20,4) NULL DEFAULT '0.0000',
	`valorpesos` DECIMAL(20,4) NULL DEFAULT '0.0000',
	`pesos` DECIMAL(20,4) NULL DEFAULT '0.0000',
	`efectivo_cop` DECIMAL(20,3) NULL DEFAULT '0.000',
	`efectivo_dolar` DECIMAL(20,3) NULL DEFAULT '0.000',
	`efectivo_cop_concil` DECIMAL(20,3) NULL DEFAULT '0.000',
	`efectivo_dolar_concil` DECIMAL(20,3) NULL DEFAULT '0.000',
	`BaseIGTFDolar` DECIMAL(16,3) NULL DEFAULT '0.000',
	`IGTFDolar` DECIMAL(16,3) NULL DEFAULT '0.000',
	`BaseIGTFCop` DECIMAL(16,3) NULL DEFAULT '0.000',
	`IGTFCop` DECIMAL(16,3) NULL DEFAULT '0.000',
	`PorcIGTF` DECIMAL(5,2) NULL DEFAULT '0.00',
	`IGTFDolarBs` DECIMAL(16,3) NULL DEFAULT '0.000',
	`IGTFCopBs` DECIMAL(16,3) NULL DEFAULT '0.000',
	`TotBaseIGTFBs` DECIMAL(16,3) NULL DEFAULT '0.000',
	`TotIGTFBs` DECIMAL(16,3) NULL DEFAULT '0.000',
	`BioPago` DECIMAL(12,3) NULL DEFAULT '0.000',
	`Cashea` DECIMAL(12,3) NULL DEFAULT '0.000',
	`CASHEABS` DECIMAL(15,3) NULL DEFAULT '0.000',
	`CasheaRef` VARCHAR(10) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`rev` CHAR(1) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`nroMesa` VARCHAR(100) NULL DEFAULT '' COLLATE 'utf8mb3_general_ci',
	`numPedido` VARCHAR(20) NOT NULL DEFAULT '' COLLATE 'utf8mb3_general_ci',
	PRIMARY KEY (`code_emp`, `id`) USING BTREE,
	INDEX `idx_cabecera_busqueda` (`code_emp`, `documento`, `activo`, `fecha`) USING BTREE,
	INDEX `idx_cabecera_mesa` (`code_emp`, `nroMesa`, `activo`, `documento`) USING BTREE,
	INDEX `idx_sync_key` (`code_emp`, `id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- ------------------------------------------------------------------------------
-- 3. TABLA: VENTA (DETALLE DE FACTURA / RENGLONES DE PEDIDO DE MESA)
--    Mapea directamente con `ModeloVentaProducto`
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `venta` (
	`id` INT NOT NULL AUTO_INCREMENT,
	`fecha` DATE NULL DEFAULT NULL,
	`rif` VARCHAR(15) NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`documento` VARCHAR(20) NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`codigoa` VARCHAR(25) NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`codigob` VARCHAR(25) NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`detalle1` VARCHAR(80) NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`detalle2` VARCHAR(80) NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`imp` DECIMAL(11,2) NULL DEFAULT '0.00',
	`cantidad` DECIMAL(20,3) NULL DEFAULT '0.000',
	`costo_a` DECIMAL(20,4) NULL DEFAULT '0.0000',
	`precio` DECIMAL(20,4) NULL DEFAULT '0.0000',
	`subtotal` DECIMAL(20,4) NULL DEFAULT '0.0000',
	`nrofiscal` VARCHAR(20) NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`nrodocreg` VARCHAR(20) NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`numgeneral` VARCHAR(20) NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`vendedor` VARCHAR(20) NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`deposito` VARCHAR(50) NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`activo` VARCHAR(20) NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`serial` VARCHAR(20) NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`preciofact` DECIMAL(20,4) NULL DEFAULT '0.0000',
	`preciodif` DECIMAL(20,4) NULL DEFAULT '0.0000',
	`subtotal2` DECIMAL(20,4) NULL DEFAULT '0.0000',
	`usuario` VARCHAR(20) NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`pos` VARCHAR(10) NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`nrozeta` VARCHAR(10) NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`maquinanro` VARCHAR(15) NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`code_emp` VARCHAR(15) NOT NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`subtotalt` DECIMAL(20,4) NULL DEFAULT '0.0000',
	`fracc` VARCHAR(20) NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`preciobase` DECIMAL(20,4) NULL DEFAULT '0.0000',
	`precioiva` DECIMAL(20,4) NULL DEFAULT '0.0000',
	`unidad` DECIMAL(11,2) NULL DEFAULT '1.00',
	`pieza` DECIMAL(11,2) NULL DEFAULT '1.00',
	`server` VARCHAR(30) NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`ntarjeta` VARCHAR(20) NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`costo_r` DECIMAL(20,4) NULL DEFAULT '0.0000',
	`dias` INT NULL DEFAULT '0',
	`costo_op` DECIMAL(20,4) NULL DEFAULT '0.0000',
	`lote` VARCHAR(30) NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`subgrupo` VARCHAR(50) NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`porcecomi` DECIMAL(20,4) NULL DEFAULT '0.0000',
	`tipocomi` VARCHAR(100) NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`comision` DECIMAL(20,4) NULL DEFAULT '0.0000',
	`tipo_empaque` VARCHAR(50) NULL DEFAULT 'UNIDAD' COLLATE 'utf8mb4_general_ci',
	`pesoequiv` DECIMAL(20,4) NULL DEFAULT '0.0000',
	`totalpeso` DECIMAL(20,4) NULL DEFAULT '0.0000',
	`totaldescontar` DECIMAL(20,4) NULL DEFAULT '0.0000',
	`porcdescuento` DECIMAL(20,4) NULL DEFAULT '0.0000',
	`price_dolar` DECIMAL(14,3) NULL DEFAULT '0.000',
	`subtotal_dolar` DECIMAL(20,3) NULL DEFAULT '0.000',
	`price_cop` DECIMAL(14,3) NULL DEFAULT '0.000',
	`subtotal_cop` DECIMAL(20,3) NULL DEFAULT '0.000',
	`Costo_Dolar` DECIMAL(16,3) NULL DEFAULT '0.000',
	`Costo_Cop` DECIMAL(16,3) NULL DEFAULT '0.000',
	`updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`rev` CHAR(1) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	PRIMARY KEY (`code_emp`, `id`) USING BTREE,
	INDEX `idx_detalle_join` (`fecha`, `activo`, `nrodocreg`, `code_emp`, `documento`) USING BTREE,
	INDEX `idx_sync_key` (`code_emp`, `id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- ==============================================================================
-- TABLAS ESPECÍFICAS DE RESTAURANTE (ZONAS, ESTACIONES, MESAS)
-- Totalmente integradas con `code_emp`, `ventaf.nroMesa`, `productos.codigoa`
-- ==============================================================================

-- ------------------------------------------------------------------------------
-- 4. TABLA: STAR_REST_ZONAS (SALÓN, TERRAZA, BARRA)
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `star_rest_zonas` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `code_emp` VARCHAR(15) NOT NULL COLLATE 'utf8mb4_general_ci',
  `codigo` VARCHAR(25) NOT NULL COLLATE 'utf8mb4_general_ci' COMMENT 'SALON, TERRAZA, BARRA',
  `nombre` VARCHAR(80) NOT NULL COLLATE 'utf8mb4_general_ci' COMMENT 'Nombre en pantalla',
  `descripcion` VARCHAR(150) NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
  `color_hex` VARCHAR(10) NOT NULL DEFAULT '#28A745' COLLATE 'utf8mb4_general_ci',
  `orden` INT(11) NOT NULL DEFAULT 1,
  `activo` VARCHAR(20) NOT NULL DEFAULT '1' COLLATE 'utf8mb4_general_ci',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`code_emp`, `id`) USING BTREE,
  UNIQUE KEY `uk_zona_emp_cod` (`code_emp`, `codigo`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- ------------------------------------------------------------------------------
-- 5. TABLA: STAR_REST_ESTACIONES (COCINA CALIENTE, COCINA FRÍA, BARRA DE TRAGOS, ETC.)
--    Permite despachar pedidos e imprimir comandas térmicas automáticamente
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `star_rest_estaciones` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `code_emp` VARCHAR(15) NOT NULL COLLATE 'utf8mb4_general_ci',
  `codigo` VARCHAR(25) NOT NULL COLLATE 'utf8mb4_general_ci' COMMENT 'COCINA, BARRA, PARRILLA',
  `nombre` VARCHAR(80) NOT NULL COLLATE 'utf8mb4_general_ci',
  `tipo` VARCHAR(30) NOT NULL DEFAULT 'cocina' COLLATE 'utf8mb4_general_ci',
  `tipo_impresora` VARCHAR(30) NOT NULL DEFAULT 'termica' COLLATE 'utf8mb4_general_ci',
  `nombre_impresora` VARCHAR(100) NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
  `ip_impresora` VARCHAR(50) NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
  `puerto_impresora` VARCHAR(10) NULL DEFAULT '9100' COLLATE 'utf8mb4_general_ci',
  `ancho_ticket` INT(11) NOT NULL DEFAULT 80,
  `auto_imprimir` INT(11) NOT NULL DEFAULT 1,
  `activo` VARCHAR(20) NOT NULL DEFAULT '1' COLLATE 'utf8mb4_general_ci',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`code_emp`, `id`) USING BTREE,
  UNIQUE KEY `uk_estacion_emp_cod` (`code_emp`, `codigo`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- ------------------------------------------------------------------------------
-- 6. TABLA: STAR_REST_MESAS
--    Casada con `code_emp`, `star_rest_zonas`, y con `ventaf.nroMesa`
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `star_rest_mesas` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `code_emp` VARCHAR(15) NOT NULL COLLATE 'utf8mb4_general_ci',
  `codigo_mesa` VARCHAR(25) NOT NULL COLLATE 'utf8mb4_general_ci' COMMENT 'M1, M2, T1, B1',
  `nombre_mesa` VARCHAR(80) NOT NULL COLLATE 'utf8mb4_general_ci' COMMENT 'MESA 1, MESA 2 (Coincide con ventaf.nroMesa)',
  `id_zona` INT(11) NOT NULL,
  `capacidad` INT(11) NOT NULL DEFAULT 4,
  `num_sillas` INT(11) NOT NULL DEFAULT 4,
  `forma` VARCHAR(20) NOT NULL DEFAULT 'rectangular' COLLATE 'utf8mb4_general_ci',
  `pos_x` DOUBLE NOT NULL DEFAULT 0,
  `pos_y` DOUBLE NOT NULL DEFAULT 0,
  `estado` ENUM('disponible', 'ocupada', 'en_cuenta', 'reservada', 'bloqueada') NOT NULL DEFAULT 'disponible',
  
  -- Campos de enlace directo con `ventaf` cuando la mesa tiene una comanda activa
  `nrodocreg_actual` VARCHAR(20) NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
  `numPedido_actual` VARCHAR(20) NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
  `vendedor_actual` VARCHAR(20) NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
  `fecha_apertura` DATETIME NULL DEFAULT NULL,
  `activo` VARCHAR(20) NOT NULL DEFAULT '1' COLLATE 'utf8mb4_general_ci',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`code_emp`, `id`) USING BTREE,
  UNIQUE KEY `uk_mesa_emp_nro` (`code_emp`, `nombre_mesa`) USING BTREE,
  INDEX `idx_mesa_zona` (`code_emp`, `id_zona`, `activo`) USING BTREE,
  INDEX `idx_mesa_estado` (`code_emp`, `estado`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- ------------------------------------------------------------------------------
-- 7. TABLA: ASIGNACIÓN DE PRODUCTOS/PLATOS A ESTACIONES DE COCINA/BARRA
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `star_rest_estacion_productos` (
  `code_emp` VARCHAR(15) NOT NULL COLLATE 'utf8mb4_general_ci',
  `codigoa` VARCHAR(25) NOT NULL COLLATE 'utf8mb4_general_ci',
  `id_estacion` INT(11) NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`code_emp`, `codigoa`) USING BTREE,
  INDEX `idx_est_prod` (`code_emp`, `id_estacion`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- ------------------------------------------------------------------------------
-- 8. TABLA: NOTAS DE PREPARACIÓN DE COMANDA (ASOCIADAS A CADA RENGLÓN DE VENTA)
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `star_rest_comanda_notas` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `code_emp` VARCHAR(15) NOT NULL COLLATE 'utf8mb4_general_ci',
  `id_venta` INT(11) NOT NULL COMMENT 'ID del renglón en tabla `venta`',
  `nota` VARCHAR(255) NOT NULL COLLATE 'utf8mb4_general_ci' COMMENT 'Ej: Sin cebolla, término medio',
  `estado_cocina` ENUM('pendiente', 'preparando', 'listo', 'servido') NOT NULL DEFAULT 'pendiente',
  `hora_pedido` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `hora_listo` DATETIME NULL DEFAULT NULL,
  `impreso` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`code_emp`, `id`) USING BTREE,
  INDEX `idx_nota_venta` (`code_emp`, `id_venta`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- ==============================================================================
-- VISTA DINÁMICA: MESAS CON SU FACTURA/COMANDA ACTIVA EN VENTAF
-- ==============================================================================
CREATE OR REPLACE VIEW `vw_star_rest_mesas_activas` AS
SELECT 
    m.id AS id_mesa,
    m.code_emp,
    m.codigo_mesa,
    m.nombre_mesa,
    m.capacidad,
    m.num_sillas,
    m.forma,
    m.pos_x,
    m.pos_y,
    m.estado,
    z.id AS id_zona,
    z.nombre AS nombre_zona,
    z.color_hex AS color_zona,
    f.id AS id_ventaf,
    f.nrodocreg,
    f.numPedido,
    f.vendedor AS nombre_mesero,
    f.fecha AS fecha_apertura,
    TIMESTAMPDIFF(MINUTE, f.fecha, NOW()) AS minutos_transcurridos,
    COALESCE(f.dolares, 0.00) AS total_dolar,
    COALESCE(f.total, 0.00) AS total_bs,
    COALESCE(COUNT(v.id), 0) AS total_items
FROM star_rest_mesas m
INNER JOIN star_rest_zonas z ON m.id_zona = z.id AND m.code_emp = z.code_emp
LEFT JOIN ventaf f ON m.code_emp = f.code_emp 
                  AND m.nombre_mesa = f.nroMesa 
                  AND f.documento = 'PEDIDO' 
                  AND f.activo = '1'
LEFT JOIN venta v ON f.code_emp = v.code_emp 
                 AND f.nrodocreg = v.nrodocreg 
                 AND v.documento = 'PEDIDO' 
                 AND v.activo = '1'
WHERE m.activo = '1'
GROUP BY m.code_emp, m.id;
