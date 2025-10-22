export function getRandomWord(): string {
  const words = [
    "apple", "grape", "chair", "table", "light", "brick", "cloud", "dream", "flame", "grass",
    "house", "knife", "lemon", "music", "night", "ocean", "pearl", "queen", "river", "stone",
    "tiger", "unity", "vivid", "whale", "zebra", "angel", "beach", "candy", "daisy", "eagle",
    "fairy", "giant", "happy", "icily", "joker", "karma", "lucky", "magic", "noble", "orbit",
    "piano", "quiet", "royal", "sugar", "toast", "under", "vapor", "world", "xenon", "youth",
    "amber", "bloom", "crown", "delta", "ember", "frost", "globe", "honor", "inbox", "jolly",
    "kneel", "latch", "mango", "nurse", "opera", "punch", "quest", "rival", "scale", "trend",
    "urban", "vocal", "witty", "xylem", "yield", "zesty", "bliss", "crisp", "dodge", "elite",
    "flair", "grasp", "haste", "index", "jumps", "lunar", "mirth", "ninth", "pluck", "quilt",
    "realm", "scent", "torch", "vague", "whirl", "wrath", "zonal", "spice", "brisk", "cliff",
    "drift", "forge", "gloom", "harsh", "imply", "jumpy", "knack", "lofty", "moist", "nerdy"
  ];

  const randomIndex = Math.floor(Math.random() * words.length);
  return words[randomIndex];
}