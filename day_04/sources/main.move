/// DAY 4: Vector + Ownership Basics
/// 
/// Today you will:
/// 1. Learn about vectors
/// 2. Create a list of habits
/// 3. Understand basic ownership concepts

module challenge::day_04 {

    // GÖREV 1:Habit yapısını aynen kullanıyoruz
    public struct Habit has copy, drop {
        name: vector<u8>,
        completed: bool,
    }

    public fun new_habit(name: vector<u8>): Habit {
        Habit {
            name,
            completed: false,
        }
    }

    // GÖREV 2: Alışkanlıkları tutacak liste yapısı (HabitList)
    // 'has drop' (liste silinince içindekiler de silsin diye)
    public struct HabitList has drop {
        habits: vector<Habit>, // İçinde Habit'ler olan bir vektör
    }

    // GÖREV 3: Boş bir liste oluşturan fonksiyon
    public fun empty_list(): HabitList {
        HabitList {
            habits: vector::empty(), // Boş bir vektör oluşturur
        }
    }

    // GÖREV 4: Listeye yeni bir alışkanlık ekleyen fonksiyon
    // 'list': Listeyi değiştireceğimiz için '&mut' (mutable reference) kullanıyoruz.
    // 'habit': Alışkanlığı alıp listenin içine koyacağız (Move/Taşıma işlemi).
    public fun add_habit(list: &mut HabitList, habit: Habit) {
        vector::push_back(&mut list.habits, habit);
    }
}