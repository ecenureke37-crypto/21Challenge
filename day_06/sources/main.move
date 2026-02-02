/// DAY 6: String Type for Habit Names
/// 
/// Today you will:
/// 1. Learn about the String type
/// 2. Convert vector<u8> to String
/// 3. Update Habit to use String instead of vector<u8>
///
/// Note: You can copy code from day_05/sources/solution.move if needed

module challenge::day_06 {
    // String modülünü ekliyoruz. 'Self' fonksiyonları, 'String' ise türü kullanmak için.
    use std::string::{Self, String}; 

    // GÖREV 1: 'name' alanını String türüne çevirdik
    public struct Habit has copy, drop {
        name: String, 
        completed: bool,
    }

    // GÖREV 2: Fonksiyon artık String kabul ediyor
    public fun new_habit(name: String): Habit {
        Habit {
            name,
            completed: false,
        }
    }

    // GÖREV 3: Baytları (vector<u8>) String'e çeviren yardımcı fonksiyon
    // Bu fonksiyon, ham veriyi alıp "utf8" formatında düzgün bir metne çevir
    public fun make_habit(name_bytes: vector<u8>): Habit {
        let name_str = string::utf8(name_bytes);
        new_habit(name_str)
    }

    public struct HabitList has drop {
        habits: vector<Habit>,
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
}