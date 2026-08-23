import 'package:flutter/material.dart';

import '../../../../app/theme/colores.dart';

class PaginaReporteVentas extends StatelessWidget {
  const PaginaReporteVentas({super.key});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final clientesFieles = <_ClienteFiel>[
      const _ClienteFiel(nombre: 'Luis Garcia', visitas: 9, totalGastado: 2150),
      const _ClienteFiel(nombre: 'Maria Fernandez', visitas: 8, totalGastado: 1890),
      const _ClienteFiel(nombre: 'Jose Aguilar', visitas: 7, totalGastado: 1680),
      const _ClienteFiel(nombre: 'Andrea Ruiz', visitas: 6, totalGastado: 1490),
    ];
    final serviciosTop = <_ItemTop>[
      const _ItemTop(nombre: 'Corte clasico', cantidad: 42),
      const _ItemTop(nombre: 'Fade / Degradado', cantidad: 36),
      const _ItemTop(nombre: 'Perfilado de barba', cantidad: 28),
      const _ItemTop(nombre: 'Lavado capilar', cantidad: 21),
    ];
    final estilosTop = <_ItemTop>[
      const _ItemTop(nombre: 'Low Fade', cantidad: 31),
      const _ItemTop(nombre: 'Taper Fade', cantidad: 24),
      const _ItemTop(nombre: 'Skin Fade', cantidad: 18),
      const _ItemTop(nombre: 'Buzz Cut', cantidad: 13),
    ];

    return Scaffold(
      backgroundColor: ColoresApp.fondo,
      appBar: AppBar(
        title: const Text('Reporte de ventas'),
        backgroundColor: ColoresApp.primario,
        foregroundColor: ColoresApp.secundario,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _encabezadoDashboard(tema),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _kpi(
                tema: tema,
                titulo: 'Ventas del dia',
                valor: 'L 4,250',
                detalle: '+12% vs ayer',
                icono: Icons.payments_outlined,
              ),
              _kpi(
                tema: tema,
                titulo: 'Servicios completados',
                valor: '18',
                detalle: 'Ticket promedio: L 236',
                icono: Icons.content_cut_outlined,
              ),
              _kpi(
                tema: tema,
                titulo: 'Clientes atendidos',
                valor: '14',
                detalle: '4 son clientes nuevos',
                icono: Icons.people_outline,
              ),
              _kpi(
                tema: tema,
                titulo: 'Metodo de pago',
                valor: 'Efectivo 60% / Visa 40%',
                detalle: 'Distribucion del dia',
                icono: Icons.credit_card_outlined,
              ),
            ],
          ),
          const SizedBox(height: 14),
          _tarjetaTendencia(
            tema: tema,
            valores: const [45, 52, 48, 63, 70, 66, 74],
            etiquetas: const ['Lun', 'Mar', 'Mie', 'Jue', 'Vie', 'Sab', 'Dom'],
          ),
          const SizedBox(height: 14),
          _tarjetaRankingClientes(tema: tema, clientes: clientesFieles),
          const SizedBox(height: 14),
          _tarjetaTopItems(
            tema: tema,
            titulo: 'Servicios mas pedidos',
            subtitulo: 'Basado en reservas confirmadas de la semana',
            icono: Icons.local_offer_outlined,
            items: serviciosTop,
          ),
          const SizedBox(height: 14),
          _tarjetaTopItems(
            tema: tema,
            titulo: 'Estilos mas pedidos',
            subtitulo: 'Preferencias de corte de tus clientes',
            icono: Icons.style_outlined,
            items: estilosTop,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _encabezadoDashboard(ThemeData tema) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ColoresApp.primario,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resumen semanal del negocio',
            style: tema.textTheme.titleMedium?.copyWith(
              color: ColoresApp.secundario,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Analiza rendimiento, fidelidad de clientes y tendencias de servicios y estilos.',
            style: tema.textTheme.bodySmall?.copyWith(
              color: ColoresApp.secundario.withValues(alpha: 0.85),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            children: const [
              _FiltroPeriodoChip(texto: 'Hoy', activo: false),
              _FiltroPeriodoChip(texto: 'Semana', activo: true),
              _FiltroPeriodoChip(texto: 'Mes', activo: false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _kpi({
    required ThemeData tema,
    required String titulo,
    required String valor,
    required String detalle,
    required IconData icono,
  }) {
    return Container(
      width: 168,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ColoresApp.secundario,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: ColoresApp.terceario.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: ColoresApp.terceario.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icono, color: ColoresApp.primario, size: 19),
          ),
          const SizedBox(height: 8),
          Text(
            titulo,
            style: tema.textTheme.labelLarge?.copyWith(
              color: ColoresApp.textoClaro,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            valor,
            style: tema.textTheme.titleMedium?.copyWith(
              color: ColoresApp.primario,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            detalle,
            style: tema.textTheme.bodySmall?.copyWith(
              color: ColoresApp.primario.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tarjetaTendencia({
    required ThemeData tema,
    required List<int> valores,
    required List<String> etiquetas,
  }) {
    final maximo = valores.reduce((a, b) => a > b ? a : b).toDouble();
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ColoresApp.secundario,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ColoresApp.terceario.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tendencia de reservas (ultimos 7 dias)',
            style: tema.textTheme.labelLarge?.copyWith(
              color: ColoresApp.primario,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 145,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(valores.length, (index) {
                final proporcion = maximo == 0 ? 0.0 : valores[index] / maximo;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          valores[index].toString(),
                          style: tema.textTheme.labelSmall?.copyWith(
                            color: ColoresApp.textoClaro,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: 16,
                              height: (95 * proporcion) + 10,
                              decoration: BoxDecoration(
                                color: ColoresApp.primario,
                                borderRadius: BorderRadius.circular(99),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          etiquetas[index],
                          style: tema.textTheme.labelSmall?.copyWith(
                            color: ColoresApp.textoClaro,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tarjetaRankingClientes({
    required ThemeData tema,
    required List<_ClienteFiel> clientes,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ColoresApp.primario,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Clientes mas fieles',
            style: tema.textTheme.titleSmall?.copyWith(
              color: ColoresApp.secundario,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          ...clientes.asMap().entries.map((entrada) {
            final posicion = entrada.key + 1;
            final cliente = entrada.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: ColoresApp.secundario.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: ColoresApp.dorado.withValues(alpha: 0.35),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    decoration: const BoxDecoration(
                      color: ColoresApp.secundario,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '$posicion',
                      style: tema.textTheme.labelMedium?.copyWith(
                        color: ColoresApp.primario,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cliente.nombre,
                          style: tema.textTheme.labelLarge?.copyWith(
                            color: ColoresApp.secundario,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '${cliente.visitas} visitas • L ${cliente.totalGastado.toStringAsFixed(0)} gastados',
                          style: tema.textTheme.bodySmall?.copyWith(
                            color: ColoresApp.secundario.withValues(alpha: 0.85),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _tarjetaTopItems({
    required ThemeData tema,
    required String titulo,
    required String subtitulo,
    required IconData icono,
    required List<_ItemTop> items,
  }) {
    final maximo = items
        .map((item) => item.cantidad)
        .reduce((a, b) => a > b ? a : b)
        .toDouble();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ColoresApp.secundario,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ColoresApp.terceario.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icono, color: ColoresApp.primario),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  titulo,
                  style: tema.textTheme.titleSmall?.copyWith(
                    color: ColoresApp.primario,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            subtitulo,
            style: tema.textTheme.bodySmall?.copyWith(
              color: ColoresApp.textoClaro,
            ),
          ),
          const SizedBox(height: 10),
          ...items.map((item) {
            final proporcion = maximo == 0 ? 0.0 : item.cantidad / maximo;
            return Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.nombre,
                          style: tema.textTheme.bodyMedium?.copyWith(
                            color: ColoresApp.primario,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Text(
                        '${item.cantidad}',
                        style: tema.textTheme.labelLarge?.copyWith(
                          color: ColoresApp.primario,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(99),
                    child: LinearProgressIndicator(
                      minHeight: 9,
                      value: proporcion,
                      backgroundColor: ColoresApp.terceario.withValues(alpha: 0.25),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        ColoresApp.primario,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _FiltroPeriodoChip extends StatelessWidget {
  const _FiltroPeriodoChip({required this.texto, required this.activo});

  final String texto;
  final bool activo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: activo
            ? ColoresApp.secundario
            : ColoresApp.secundario.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        texto,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: activo ? ColoresApp.primario : ColoresApp.secundario,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ClienteFiel {
  const _ClienteFiel({
    required this.nombre,
    required this.visitas,
    required this.totalGastado,
  });

  final String nombre;
  final int visitas;
  final double totalGastado;
}

class _ItemTop {
  const _ItemTop({required this.nombre, required this.cantidad});

  final String nombre;
  final int cantidad;
}
