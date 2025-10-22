import styles from '../styles/Home.module.css';
import { letterState } from '../utils/letterState';

const ROWS = 5
const COLUMNS = 5

interface Props{
  guesses: string[]
  currentGuess: string
  solution: string
}

export default function Grid({guesses, currentGuess, solution}: Props) {
    const allGuesses = [...guesses];
    
    if (currentGuess) allGuesses.push(currentGuess);

    while (allGuesses.length < ROWS) allGuesses.push(''); 

    return(
        <div className={styles.grid}>
            {Array(ROWS)
            .fill(undefined)
            .map((_,rowIndex) =>{
                const isComplete = guesses.length > rowIndex;
                const states = isComplete 
                    ? letterState(allGuesses[rowIndex],solution)
                    : Array(5).fill('');
                return (
                    <div key={rowIndex} className={styles.row}>
                        {Array(COLUMNS)
                        .fill(undefined)
                        .map((_,colIndex) =>{
                            const letter = allGuesses[rowIndex]?.[colIndex] || ''
                            const letterState = states[colIndex];

                            const stateClass =
                              letterState === 'correct'
                                ? styles.correct
                                : letterState === 'present'
                                ? styles.present
                                : letterState === 'absent'
                                ? styles.absent
                                : styles.letter;
                            
                            return(
                                <div 
                                key={`${rowIndex}-${colIndex}`} 
                                className={stateClass}
                                >
                                    {letter}
                                </div>
                            )
                        })}
                    </div>
                )
            })}
        </div>
    )
}   