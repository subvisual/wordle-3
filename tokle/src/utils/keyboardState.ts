import { letterState } from "./letterState";

export function keyboardState(guesses: string[], solution: string) {
  const keyStates: Record<string, string> = {};

  guesses.forEach((guess) => {
    if (!guess) return;
    
    const states = letterState(guess, solution);
    const guessChars = guess.split('')

    guessChars.forEach((letter, i) => {
      const currentState = keyStates[letter] || 'unused';
      const newState = states[i];

      if (currentState === 'correct') return;
      if (currentState === 'present' && newState !== 'correct') return;

      keyStates[letter] = newState;
    });
  });

  return keyStates;
}