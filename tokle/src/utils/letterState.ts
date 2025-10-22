export function letterState(guess: string, solution:string) : string[] {
    if (!guess || !solution) return Array(5).fill('');

    const states = Array(5).fill('absent');
    const solutionChars = solution.split('');
    const guessChars = guess.split('');

    // Correct
    guessChars.forEach((char,i) => {
        if (char === solutionChars[i]){
            states[i] = 'correct';
            solutionChars[i] = '';
        }
    })

    // Wrong place
    guessChars.forEach((char,i) => {
        if (states[i] === 'correct') return ;

        const solutionIndex = solutionChars.indexOf(char);
        if (solutionIndex != -1) {
            states[i] = 'present';
            solutionChars[solutionIndex] = ''; 
        }
    })

    return states;
}