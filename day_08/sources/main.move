/// DAY 8: New Module & Simple Task Struct
/// 
/// Today you will:
/// 1. Start a new project: Task Bounty Board
/// 2. Create a Task struct
/// 3. Write a constructor function

module challenge::day_08 {
    use std::string::String;

    // GÖREV 1: 'Task' (Görev) yapısını oluştur
    // Bir görevin başlığı, ödül miktarı ve yapılıp yapılmadığı bilgisi olacak.
    public struct Task has copy, drop {
        title: String,
        reward: u64,
        done: bool,
    }

    // GÖREV 2: Yeni görev oluşturan fonksiyon (Constructor)
    public fun new_task(title: String, reward: u64): Task {
        Task {
            title,
            reward,
            done: false, // Görev ilk açıldığında henüz yapılmamıştır (false)
        }
    }
}
