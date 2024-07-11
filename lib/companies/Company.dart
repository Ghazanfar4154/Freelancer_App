class Company {
  final String name;
  final String logoPath;
  final String aboutUs;
  final String address;
  final String phone;
  final String website;

  Company({
    required this.name,
    required this.logoPath,
    required this.aboutUs,
    required this.address,
    required this.phone,
    required this.website,
  });


  static final List<Company> companies = [
    Company(
      name: 'Apple Inc.',
      logoPath: 'assets/images/companies_logo/apple.png',
      aboutUs: 'Apple Inc. is an American multinational technology company headquartered in Cupertino, California, that designs, develops, and sells consumer electronics, computer software, and online services.',
      address: 'One Apple Park Way, Cupertino, CA 95014, USA',
      phone: '+1-408-996-1010',
      website: 'https://www.apple.com',
    ),
    Company(
      name: 'Google LLC',
      logoPath: 'assets/images/companies_logo/google.png',
      aboutUs: 'Google LLC is an American multinational technology company that specializes in Internet-related services and products, which include online advertising technologies, a search engine, cloud computing, software, and hardware.',
      address: '1600 Amphitheatre Parkway, Mountain View, CA 94043, USA',
      phone: '+1-650-253-0000',
      website: 'https://www.google.com',
    ),
    Company(
      name: 'Amazon.com',
      logoPath: 'assets/images/companies_logo/amazon.png',
      aboutUs: 'Amazon.com, Inc. is an American multinational technology company based in Seattle, Washington, that focuses on e-commerce, cloud computing, digital streaming, and artificial intelligence.',
      address: '410 Terry Ave North, Seattle, WA 98109, USA',
      phone: '+1-206-266-1000',
      website: 'https://www.amazon.com',
    ),
    Company(
      name: 'Microsoft Corporation',
      logoPath: 'assets/images/companies_logo/microsoft.png',
      aboutUs: 'Microsoft Corporation is an American multinational technology company with headquarters in Redmond, Washington. It develops, manufactures, licenses, supports, and sells computer software, consumer electronics, personal computers, and related services.',
      address: 'One Microsoft Way, Redmond, WA 98052, USA',
      phone: '+1-425-882-8080',
      website: 'https://www.microsoft.com',
    ),
  ];
}




