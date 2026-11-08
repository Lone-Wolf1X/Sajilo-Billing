/// Bundled demo products from products.json for testing
const String bundledProductsJson = r'''{
  "shopName": "Electronics & Watch Center",
  "currency": "NPR",
  "products": [
    {
      "id": 1,
      "productName": "Casio Digital Watch",
      "category": "Watches",
      "quantity": 10,
      "price": 2500,
      "unit": "piece"
    },
    {
      "id": 2,
      "productName": "Sonata Analog Watch",
      "category": "Watches",
      "quantity": 15,
      "price": 1800,
      "unit": "piece"
    },
    {
      "id": 3,
      "productName": "Fastrack Men's Watch",
      "category": "Watches",
      "quantity": 8,
      "price": 3200,
      "unit": "piece"
    },
    {
      "id": 4,
      "productName": "Ladies Wrist Watch",
      "category": "Watches",
      "quantity": 12,
      "price": 1500,
      "unit": "piece"
    },
    {
      "id": 5,
      "productName": "Watch Battery",
      "category": "Watch Parts",
      "quantity": 50,
      "price": 100,
      "unit": "piece"
    },
    {
      "id": 6,
      "productName": "Watch Strap Leather",
      "category": "Watch Parts",
      "quantity": 20,
      "price": 250,
      "unit": "piece"
    },
    {
      "id": 7,
      "productName": "Watch Strap Metal",
      "category": "Watch Parts",
      "quantity": 15,
      "price": 350,
      "unit": "piece"
    },
    {
      "id": 8,
      "productName": "Watch Glass",
      "category": "Watch Parts",
      "quantity": 30,
      "price": 150,
      "unit": "piece"
    },
    {
      "id": 9,
      "productName": "Watch Repair Service",
      "category": "Watch Repair",
      "quantity": 999,
      "price": 200,
      "unit": "service"
    },
    {
      "id": 10,
      "productName": "Samsung Galaxy A05",
      "category": "Mobile Phones",
      "quantity": 5,
      "price": 12500,
      "unit": "piece"
    },
    {
      "id": 11,
      "productName": "Redmi A3",
      "category": "Mobile Phones",
      "quantity": 7,
      "price": 11000,
      "unit": "piece"
    },
    {
      "id": 12,
      "productName": "Nokia 105",
      "category": "Mobile Phones",
      "quantity": 10,
      "price": 2500,
      "unit": "piece"
    },
    {
      "id": 13,
      "productName": "Rechargeable LED Torch",
      "category": "Torches",
      "quantity": 20,
      "price": 650,
      "unit": "piece"
    },
    {
      "id": 14,
      "productName": "Heavy Duty Torch",
      "category": "Torches",
      "quantity": 12,
      "price": 950,
      "unit": "piece"
    },
    {
      "id": 15,
      "productName": "Mini LED Torch",
      "category": "Torches",
      "quantity": 25,
      "price": 250,
      "unit": "piece"
    },
    {
      "id": 16,
      "productName": "Portable FM Radio",
      "category": "Radios",
      "quantity": 10,
      "price": 850,
      "unit": "piece"
    },
    {
      "id": 17,
      "productName": "Rechargeable Radio",
      "category": "Radios",
      "quantity": 8,
      "price": 1200,
      "unit": "piece"
    },
    {
      "id": 18,
      "productName": "Bluetooth Speaker Radio",
      "category": "Radios",
      "quantity": 6,
      "price": 1800,
      "unit": "piece"
    },
    {
      "id": 19,
      "productName": "USB Type-C Charger",
      "category": "Mobile Accessories",
      "quantity": 30,
      "price": 450,
      "unit": "piece"
    },
    {
      "id": 20,
      "productName": "Micro USB Charger",
      "category": "Mobile Accessories",
      "quantity": 25,
      "price": 300,
      "unit": "piece"
    },
    {
      "id": 21,
      "productName": "Type-C Data Cable",
      "category": "Mobile Accessories",
      "quantity": 40,
      "price": 200,
      "unit": "piece"
    },
    {
      "id": 22,
      "productName": "Mobile Earphones",
      "category": "Mobile Accessories",
      "quantity": 20,
      "price": 350,
      "unit": "piece"
    },
    {
      "id": 23,
      "productName": "Bluetooth Earbuds",
      "category": "Mobile Accessories",
      "quantity": 10,
      "price": 1200,
      "unit": "piece"
    },
    {
      "id": 24,
      "productName": "Tempered Glass",
      "category": "Mobile Accessories",
      "quantity": 50,
      "price": 150,
      "unit": "piece"
    },
    {
      "id": 25,
      "productName": "Mobile Back Cover",
      "category": "Mobile Accessories",
      "quantity": 35,
      "price": 250,
      "unit": "piece"
    },
    {
      "id": 26,
      "productName": "Power Bank 10000mAh",
      "category": "Mobile Accessories",
      "quantity": 8,
      "price": 1800,
      "unit": "piece"
    },
    {
      "id": 27,
      "productName": "Mobile Holder",
      "category": "Mobile Accessories",
      "quantity": 15,
      "price": 300,
      "unit": "piece"
    },
    {
      "id": 28,
      "productName": "OTG Adapter",
      "category": "Mobile Accessories",
      "quantity": 20,
      "price": 120,
      "unit": "piece"
    },
    {
      "id": 29,
      "productName": "Mobile Speaker",
      "category": "Mobile Parts",
      "quantity": 15,
      "price": 400,
      "unit": "piece"
    },
    {
      "id": 30,
      "productName": "Mobile Charging Pin",
      "category": "Mobile Parts",
      "quantity": 25,
      "price": 180,
      "unit": "piece"
    },
  {
    "id": 31,
    "productName": "Casio Analog Watch",
    "category": "Watches",
    "quantity": 8,
    "price": 2200,
    "unit": "piece"
  },
  {
    "id": 32,
    "productName": "Digital Sports Watch",
    "category": "Watches",
    "quantity": 12,
    "price": 1200,
    "unit": "piece"
  },
  {
    "id": 33,
    "productName": "Kids Cartoon Watch",
    "category": "Watches",
    "quantity": 15,
    "price": 500,
    "unit": "piece"
  },
  {
    "id": 34,
    "productName": "Watch Chain",
    "category": "Watch Parts",
    "quantity": 20,
    "price": 200,
    "unit": "piece"
  },
  {
    "id": 35,
    "productName": "Watch Machine",
    "category": "Watch Parts",
    "quantity": 10,
    "price": 400,
    "unit": "piece"
  },
  {
    "id": 36,
    "productName": "Watch Crown",
    "category": "Watch Parts",
    "quantity": 30,
    "price": 80,
    "unit": "piece"
  },
  {
    "id": 37,
    "productName": "Watch Spring Bar",
    "category": "Watch Parts",
    "quantity": 50,
    "price": 20,
    "unit": "piece"
  },
  {
    "id": 38,
    "productName": "Watch Repair Service",
    "category": "Watch Repair",
    "quantity": 999,
    "price": 300,
    "unit": "service"
  },
  {
    "id": 39,
    "productName": "Samsung Galaxy A15",
    "category": "Mobile Phones",
    "quantity": 4,
    "price": 22000,
    "unit": "piece"
  },
  {
    "id": 40,
    "productName": "Redmi 13C",
    "category": "Mobile Phones",
    "quantity": 6,
    "price": 14000,
    "unit": "piece"
  },
  {
    "id": 41,
    "productName": "Nokia 110",
    "category": "Mobile Phones",
    "quantity": 8,
    "price": 2800,
    "unit": "piece"
  },
  {
    "id": 42,
    "productName": "Itel A70",
    "category": "Mobile Phones",
    "quantity": 5,
    "price": 9500,
    "unit": "piece"
  },
  {
    "id": 43,
    "productName": "Feature Phone Battery",
    "category": "Mobile Parts",
    "quantity": 25,
    "price": 250,
    "unit": "piece"
  },
  {
    "id": 44,
    "productName": "Mobile LCD Display",
    "category": "Mobile Parts",
    "quantity": 10,
    "price": 1200,
    "unit": "piece"
  },
  {
    "id": 45,
    "productName": "Mobile Touch Screen",
    "category": "Mobile Parts",
    "quantity": 8,
    "price": 900,
    "unit": "piece"
  },
  {
    "id": 46,
    "productName": "Mobile Charging Connector",
    "category": "Mobile Parts",
    "quantity": 30,
    "price": 150,
    "unit": "piece"
  },
  {
    "id": 47,
    "productName": "Rechargeable Emergency Light",
    "category": "Torches",
    "quantity": 12,
    "price": 1100,
    "unit": "piece"
  },
  {
    "id": 48,
    "productName": "LED Head Torch",
    "category": "Torches",
    "quantity": 15,
    "price": 550,
    "unit": "piece"
  },
  {
    "id": 49,
    "productName": "Mini Keychain Torch",
    "category": "Torches",
    "quantity": 30,
    "price": 150,
    "unit": "piece"
  },
  {
    "id": 50,
    "productName": "Solar Rechargeable Torch",
    "category": "Torches",
    "quantity": 10,
    "price": 1400,
    "unit": "piece"
  },
  {
    "id": 51,
    "productName": "Pocket FM Radio",
    "category": "Radios",
    "quantity": 10,
    "price": 600,
    "unit": "piece"
  },
  {
    "id": 52,
    "productName": "USB Rechargeable Radio",
    "category": "Radios",
    "quantity": 8,
    "price": 1000,
    "unit": "piece"
  },
  {
    "id": 53,
    "productName": "Mini Bluetooth Speaker",
    "category": "Radios",
    "quantity": 12,
    "price": 950,
    "unit": "piece"
  },
  {
    "id": 54,
    "productName": "FM Antenna",
    "category": "Radio Parts",
    "quantity": 20,
    "price": 100,
    "unit": "piece"
  },
  {
    "id": 55,
    "productName": "Radio Speaker",
    "category": "Radio Parts",
    "quantity": 15,
    "price": 250,
    "unit": "piece"
  },
  {
    "id": 56,
    "productName": "Wireless Neckband",
    "category": "Mobile Accessories",
    "quantity": 10,
    "price": 850,
    "unit": "piece"
  },
  {
    "id": 57,
    "productName": "Bluetooth Headset",
    "category": "Mobile Accessories",
    "quantity": 8,
    "price": 1100,
    "unit": "piece"
  },
  {
    "id": 58,
    "productName": "20W Fast Charger",
    "category": "Mobile Accessories",
    "quantity": 15,
    "price": 750,
    "unit": "piece"
  },
  {
    "id": 59,
    "productName": "65W Universal Charger",
    "category": "Mobile Accessories",
    "quantity": 8,
    "price": 1500,
    "unit": "piece"
  },
  {
    "id": 60,
    "productName": "iPhone Lightning Cable",
    "category": "Mobile Accessories",
    "quantity": 20,
    "price": 350,
    "unit": "piece"
  },
  {
    "id": 61,
    "productName": "Micro USB Data Cable",
    "category": "Mobile Accessories",
    "quantity": 30,
    "price": 150,
    "unit": "piece"
  },
  {
    "id": 62,
    "productName": "Wireless Charging Pad",
    "category": "Mobile Accessories",
    "quantity": 5,
    "price": 1200,
    "unit": "piece"
  },
  {
    "id": 63,
    "productName": "Car Mobile Charger",
    "category": "Mobile Accessories",
    "quantity": 12,
    "price": 450,
    "unit": "piece"
  },
  {
    "id": 64,
    "productName": "Car Mobile Holder",
    "category": "Mobile Accessories",
    "quantity": 10,
    "price": 350,
    "unit": "piece"
  },
  {
    "id": 65,
    "productName": "OTG Type-C Adapter",
    "category": "Mobile Accessories",
    "quantity": 25,
    "price": 150,
    "unit": "piece"
  },
  {
    "id": 66,
    "productName": "SIM Card Adapter",
    "category": "Mobile Accessories",
    "quantity": 30,
    "price": 50,
    "unit": "piece"
  },
  {
    "id": 67,
    "productName": "Mobile Ring Holder",
    "category": "Mobile Accessories",
    "quantity": 20,
    "price": 100,
    "unit": "piece"
  },
  {
    "id": 68,
    "productName": "Phone Cleaning Kit",
    "category": "Mobile Accessories",
    "quantity": 15,
    "price": 180,
    "unit": "piece"
  },
  {
    "id": 69,
    "productName": "Universal Mobile Battery",
    "category": "Mobile Parts",
    "quantity": 15,
    "price": 500,
    "unit": "piece"
  },
  {
    "id": 70,
    "productName": "Mobile Mic",
    "category": "Mobile Parts",
    "quantity": 20,
    "price": 180,
    "unit": "piece"
  },
  {
    "id": 71,
    "productName": "Mobile Ringer Speaker",
    "category": "Mobile Parts",
    "quantity": 20,
    "price": 200,
    "unit": "piece"
  },
  {
    "id": 72,
    "productName": "Mobile Power Button",
    "category": "Mobile Parts",
    "quantity": 25,
    "price": 100,
    "unit": "piece"
  },
  {
    "id": 73,
    "productName": "USB Flash Drive 32GB",
    "category": "Storage Accessories",
    "quantity": 12,
    "price": 550,
    "unit": "piece"
  },
  {
    "id": 74,
    "productName": "Memory Card 64GB",
    "category": "Storage Accessories",
    "quantity": 10,
    "price": 850,
    "unit": "piece"
  },
  {
    "id": 75,
    "productName": "Card Reader",
    "category": "Storage Accessories",
    "quantity": 15,
    "price": 200,
    "unit": "piece"
  },
  {
    "id": 76,
    "productName": "Universal Remote",
    "category": "Electronics",
    "quantity": 10,
    "price": 350,
    "unit": "piece"
  },
  {
    "id": 77,
    "productName": "Extension Board",
    "category": "Electronics",
    "quantity": 12,
    "price": 650,
    "unit": "piece"
  },
  {
    "id": 78,
    "productName": "USB LED Light",
    "category": "Electronics",
    "quantity": 20,
    "price": 150,
    "unit": "piece"
  },
  {
    "id": 79,
    "productName": "Rechargeable Table Lamp",
    "category": "Electronics",
    "quantity": 8,
    "price": 850,
    "unit": "piece"
  },
  {
    "id": 80,
    "productName": "Digital Alarm Clock",
    "category": "Electronics",
    "quantity": 10,
    "price": 750,
    "unit": "piece"
    }
  ]
}''';
