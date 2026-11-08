import 'package:flutter/material.dart';
import '../domain/print_format.dart';

/// Reusable dropdown widget to choose invoice printing format.
class PrintFormatDropdown extends StatelessWidget {
  final PrintFormat selectedFormat;
  final ValueChanged<PrintFormat> onChanged;

  const PrintFormatDropdown({
    super.key,
    required this.selectedFormat,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<PrintFormat>(
      value: selectedFormat,
      decoration: const InputDecoration(
        labelText: 'Print Format / ढाँचा',
        prefixIcon: Icon(Icons.print_outlined),
        isDense: true,
      ),
      items: PrintFormat.values.map((format) {
        return DropdownMenuItem<PrintFormat>(
          value: format,
          child: Row(
            children: [
              Icon(
                format.isThermal ? Icons.receipt_long : Icons.description_outlined,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(format.label, style: const TextStyle(fontSize: 13)),
            ],
          ),
        );
      }).toList(),
      onChanged: (val) {
        if (val != null) onChanged(val);
      },
    );
  }
}

