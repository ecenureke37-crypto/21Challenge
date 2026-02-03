/// DAY 7: Unit Tests for Habit Tracker
///
/// Today you will:
/// 1. Learn how to write tests in Move
/// 2. Write tests for your habit tracker
/// 3. Use assert! macro
///
/// Note: You can copy code from day_06/sources/solution.move if needed
module challenge::day_07 {
    use std::string::{Self, String};

    // YAPILAR (STRUCTS)

    public struct Habit has copy, drop {
        name: String,
        completed: bool,
    }

    public struct HabitList has drop {
        habits: vector<Habit>,
    }
    // FONKSİYONLAR

    public fun new_habit(name: String): Habit {
        Habit {
            name,
            completed: false,
        }
    }

    public fun make_habit(name_bytes: vector<u8>): Habit {
        let name = string::utf8(name_bytes);
        new_habit(name)
    }

    public fun empty_list(): HabitList {
        HabitList {
            habits: vector::empty(),
        }
    }

    public fun add_habit(list: &mut HabitList, habit: Habit) {
        vector::push_back(&mut list.habits, habit);
    }

    public fun complete_habit(list: &mut HabitList, index: u64) {
        let len = vector::length(&list.habits);
        if (index < len) {
            let habit = vector::borrow_mut(&mut list.habits, index);
            habit.completed = true;
        }
    }

    // TESTLER

    // TEST 1: Listeye ekleme çalışıyor mu
    #[test]
    fun test_add_habits() {
        let mut list = empty_list();
        let habit = make_habit(b"Kod Yaz"); // 'b' harfi byte string demektir

        add_habit(&mut list, habit);

        // Listenin uzunluğu 1 olmalı. Değilse hata kodu '0' fırlat.
        assert!(vector::length(&list.habits) == 1, 0);
    }

    // TEST 2: Tamamlama özelliği çalışıyor mu
    #[test]
    fun test_complete_habit() {
        let mut list = empty_list();
        let habit = make_habit(b"Su Ic");
        
        add_habit(&mut list, habit);

        // 0. sıradaki alışkanlığı tamamla
        complete_habit(&mut list, 0);

        // Kontrol et: true oldu mu
        let habit_ref = vector::borrow(&list.habits, 0);
        assert!(habit_ref.completed == true, 1);
    }
}