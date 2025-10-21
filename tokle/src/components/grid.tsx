import styles from '../styles/Home.module.css';

const ROWS = 5
const COLUMNS = 5

interface Props{
  guesses: string[]
}

export default function Grid({guesses}: Props) {
    const currentGuesses = guesses || Array(ROWS).fill('')

    return(
        <div className={styles.grid}>
            {Array(ROWS)
            .fill(undefined)
            .map((_,rowIndex) =>{
                return (
                    <div key={rowIndex} className={styles.row}>
                        {Array(COLUMNS)
                        .fill(undefined)
                        .map((_,colIndex) =>{
                            const letter = currentGuesses[rowIndex]?.[colIndex] || ''
                            return(
                                <div key={`${rowIndex}-${colIndex}`} className={styles.letter}>
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