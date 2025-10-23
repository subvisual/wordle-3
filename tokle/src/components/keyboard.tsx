import { useEffect } from 'react';
import styles from '../styles/Home.module.css';

const KEYBOARD_ROWS = [
    ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
    ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'],
    ['Enter','Z', 'X', 'C', 'V', 'B', 'N', 'M','Backspace']
]

interface Props{
    states: Record<string, string> ;
    onKeyPress: (key: string) => void
}

export default function Keyboard({states, onKeyPress} : Props){
    useEffect(() => {
        const handleKeyDown = (event:KeyboardEvent) => {
                const key = event.key;

                if (key === 'Enter' || key === 'Backspace' || /^[A-Za-z]$/.test(key)){
                    event.preventDefault();
                    onKeyPress(key.toLowerCase())
                }
        }

        window.addEventListener('keydown', handleKeyDown);
        return () => window.removeEventListener('keydown',handleKeyDown)
    })

    return(
        <div className={styles.keyboard}>
            {KEYBOARD_ROWS.map((row,rowIndex) => {
                return (
                <div key={rowIndex} className={styles.keyboardRow}>
                    {row.map((key) => {
                        const state = key.length === 1 ? states[key.toLowerCase()] : ''

                        const stateClass =
                          state === 'correct'
                            ? styles.correctKey
                            : state === 'present'
                            ? styles.presentKey
                            : state === 'absent'
                            ? styles.absentKey
                            : styles.keyboardKey;
                        return (
                            <button
                            key={key}
                            onClick={() => onKeyPress(key.toLowerCase())}
                            className={stateClass}>
                                {key === 'Backspace' ? '⌫' :key}
                            </button>
                        )
                    })}
                </div>
                )
            })}
        </div>
    )
}