/// DAY 3: Structs (Habit Model Skeleton)
/// 
/// Today you will:
/// 1. Learn about structs
/// 2. Create a Habit struct
/// 3. Write a constructor function

 module challenge::day_03 {
    // GÖREV 1: 'Habit' (Alışkanlık) yapısı
    public struct Habit has copy, drop {
        name: vector<u8>, 
        completed: bool, 
    }

    // GÖREV 2: Yeni alışkanlık oluşturan fonksiyon
    public fun new_habit(name: vector<u8>): Habit {
        Habit {
            name: name,      
            completed: false 
        }
    }
}