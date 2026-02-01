/// DAY 5: Control Flow & Mark Habit as Done
/// 
/// Today you will:
/// 1. Learn if/else statements
/// 2. Learn how to access vector elements
/// 3. Write a function to mark a habit as completed

module challenge::day_05 {

    // YAPILAR (STRUCTS)

    public struct Habit has copy, drop {
        name: vector<u8>,
        completed: bool,
    }

    public struct HabitList has drop {
        habits: vector<Habit>,
    }

    //FONKSİYONLAR

    public fun new_habit(name: vector<u8>): Habit {
        Habit {
            name,
            completed: false,
        }
    }

    public fun empty_list(): HabitList {
        HabitList {
            habits: vector::empty(),
        }
    }

    public fun add_habit(list: &mut HabitList, habit: Habit) {
        vector::push_back(&mut list.habits, habit);
    }

    // GÖREV: Alışkanlığı tamamlandı olarak işaretle
    public fun complete_habit(list: &mut HabitList, index: u64) {
        // 1. Listenin uzunluğunu al
        let len = vector::length(&list.habits);

        // 2. Verilen index (sıra no) geçerli mi diye kontrol ediyoruz
        // Örneğin listede 3 eleman varsa ama biz 5. elemanı istersek hata verir.
        if (index < len) {
            // 3. O sıradaki alışkanlığı değiştirilebilir (mutable) olarak alıyoruz
            let habit_ref = vector::borrow_mut(&mut list.habits, index);
            
            // 4. Durumunu 'true' (tamamlandı) yapıyoruz
            habit_ref.completed = true;
        }
    }
}