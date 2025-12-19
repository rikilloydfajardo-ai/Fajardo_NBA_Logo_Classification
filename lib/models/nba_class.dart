class NBAClass {
  final int id;
  final String name;
  final String description;
  final String imagePath; // Asset path
  final List<String> facts;
  final String coach;
  final String arena;
  final String foundedYear;

  const NBAClass({
    required this.id,
    required this.name,
    required this.description,
    required this.imagePath,
    required this.facts,
    required this.coach,
    required this.arena,
    required this.foundedYear,
  });
}

// Hardcoded data based on labels.txt
const List<NBAClass> nbaClasses = [
  NBAClass(
    id: 0,
    name: 'Los Angeles Lakers',
    description:
        'One of the most successful teams in NBA history, the Lakers share the record for most NBA championships. Based in Los Angeles, they are known for their "Showtime" era and legendary players like Magic Johnson, Kobe Bryant, and LeBron James.',
    imagePath: 'assets/images/lakers_logo.png',
    facts: [
      '17 NBA Championships',
      'Home to the all-time leading scorer LeBron James',
      'The name "Lakers" comes from the team\'s origin in Minnesota ("Land of 10,000 Lakes")',
    ],
    coach: 'Darvin Ham',
    arena: 'Crypto.com Arena',
    foundedYear: '1947',
  ),
  NBAClass(
    id: 1,
    name: 'Boston Celtics',
    description:
        'The Celtics are one of the most storied franchises in sports history. Their rivalry with the Lakers is legendary. They are defined by their "Ubuntu" team-first culture and the dominance of the Bill Russell era.',
    imagePath: 'assets/images/celtics_logo.webp',
    facts: [
      '17 NBA Championships (Tied for most)',
      'Won 8 consecutive titles from 1959-1966',
      'Play on a unique parquet floor',
    ],
    coach: 'Joe Mazzulla',
    arena: 'TD Garden',
    foundedYear: '1946',
  ),
  NBAClass(
    id: 2,
    name: 'Chicago Bulls',
    description:
        'Global icons of the 1990s, the Bulls won six championships behind Michael Jordan and Scottie Pippen. They popularized the NBA worldwide.',
    imagePath: 'assets/images/bulls_logo.jpg',
    facts: [
      '6 NBA Championships (two "three-peats")',
      'The only NBA franchise to never lose an NBA Finals series',
      'Michael Jordan won 5 MVPs with the team',
    ],
    coach: 'Billy Donovan',
    arena: 'United Center',
    foundedYear: '1966',
  ),
  NBAClass(
    id: 3,
    name: 'Brooklyn Nets',
    description:
        'Formerly the New Jersey Nets, they moved to Brooklyn in 2012, bringing a hip, modern brand to the NBA. They have a strong street culture influence.',
    imagePath: 'assets/images/nets_logo.jpg',
    facts: [
      '2 ABA Championships (Pre-NBA)',
      'First major pro sports team in Brooklyn since 1957',
      'Jay-Z was a former minority owner',
    ],
    coach: 'Jacque Vaughn',
    arena: 'Barclays Center',
    foundedYear: '1967',
  ),
  NBAClass(
    id: 4,
    name: 'Golden State Warriors',
    description:
        'The Warriors revolutionized modern basketball with their reliance on three-point shooting, led by Stephen Curry. Their dynasty in the 2010s resulted in multiple championships.',
    imagePath: 'assets/images/warriors_logo.jpg',
    facts: [
      '7 NBA Championships',
      'Set record for most wins in a regular season (73-9)',
      'Originally from Philadelphia',
    ],
    coach: 'Steve Kerr',
    arena: 'Chase Center',
    foundedYear: '1946',
  ),
  NBAClass(
    id: 5,
    name: 'Dallas Mavericks',
    description:
        'The Mavericks won their first title in 2011 led by Dirk Nowitzki against the Miami Heat "Big 3". They are known for international talent integration.',
    imagePath: 'assets/images/mavericks_logo.webp',
    facts: [
      '1 NBA Championship (2011)',
      'Owned by Mark Cuban',
      'Sold out every home game since 2001',
    ],
    coach: 'Jason Kidd',
    arena: 'American Airlines Center',
    foundedYear: '1980',
  ),
  NBAClass(
    id: 6,
    name: 'Phoenix Suns',
    description:
        'The Suns have been an offensive powerhouse throughout their history, notably the "7 Seconds or Less" era. They are a constant contender in the West.',
    imagePath: 'assets/images/suns_logo.jpg',
    facts: [
      '3 Conference titles',
      'First team to have a gorilla as a mascot',
      'Known for their 1993 Finals run with Charles Barkley',
    ],
    coach: 'Frank Vogel',
    arena: 'Footprint Center',
    foundedYear: '1968',
  ),
  NBAClass(
    id: 7,
    name: 'Miami Heat',
    description:
        'Known for "Heat Culture"—the hardest working, best conditioned, most professional, unselfish, toughest, meanest, nastiest team in the NBA. Famous for the Wade & LeBron era.',
    imagePath: 'assets/images/heat_logo.jpg',
    facts: [
      '3 NBA Championships',
      'The "Big Three" era (James, Wade, Bosh) reached 4 straight finals',
      'Pat Riley has been with the team since 1995',
    ],
    coach: 'Erik Spoelstra',
    arena: 'Kaseya Center',
    foundedYear: '1988',
  ),
  NBAClass(
    id: 8,
    name: 'San Antonio Spurs',
    description:
        'The Spurs are the epitome of consistency, making the playoffs for 22 consecutive seasons. Under Gregg Popovich, they focus on fundamentals and team play.',
    imagePath: 'assets/images/spurs_logo.jpg',
    facts: [
      '5 NBA Championships',
      'Highest winning percentage of any active NBA franchise',
      'Developed the "Beautiful Game" style of play',
    ],
    coach: 'Gregg Popovich',
    arena: 'Frost Bank Center',
    foundedYear: '1967',
  ),
  NBAClass(
    id: 9,
    name: 'Houston Rockets',
    description:
        'Known for "Clutch City" when they won back-to-back titles in the 90s with Hakeem Olajuwon. They often embrace analytical approaches to the game.',
    imagePath: 'assets/images/rockets_logo.png',
    facts: [
      '2 NBA Championships',
      'Horns set play was popularized here',
      'Yao Ming brought massive popularity in China',
    ],
    coach: 'Ime Udoka',
    arena: 'Toyota Center',
    foundedYear: '1967',
  ),
];
