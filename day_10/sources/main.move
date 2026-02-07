/// DAY 10: Visibility Modifiers (Public vs Private Functions)
/// 
/// Today you will:
/// 1. Learn about visibility modifiers (public vs private)
/// 2. Design a public API
/// 3. Write a function to complete tasks
///
/// Note: You can copy code from day_09/sources/solution.move if needed

module challenge::day_10 {
    use std::string::String;

    // --- YAPILAR ve ENUM ---

    public enum TaskStatus has copy, drop {
        Open,
        Completed,
    }

    public struct Task has copy, drop {
        title: String,
        reward: u64,
        status: TaskStatus,
    }

    // --- PUBLIC FONKSİYONLAR (Dışarıya Açık) ---

    public fun new_task(title: String, reward: u64): Task {
        Task {
            title,
            reward,
            status: TaskStatus::Open,
        }
    }

    public fun is_open(task: &Task): bool {
        task.status == TaskStatus::Open
    }

    // GÖREV 1: Görevi tamamlayan PUBLIC fonksiyon
    // Bu fonksiyon dışarıdan çağrılabilir, çünkü başında 'public' var.
    public fun complete_task(task: &mut Task) {
        task.status = TaskStatus::Completed;
    }

    // --- PRIVATE FONKSİYONLAR (Gizli) ---

    // GÖREV 2: Yardımcı Gizli Fonksiyon (BONUS)
    // Başında 'public' YOK. Sadece bu dosya içindeki diğer fonksiyonlar kullanabilir.
    fun check_reward_threshold(reward: u64): bool {
        reward > 100 // Ödül 100'den büyük mü?
    }

    // Bu public fonksiyon, yukarıdaki gizli fonksiyonu kullanır.
    public fun is_high_reward(task: &Task): bool {
        // Gizli fonksiyonu buradan çağırıyoruz:
        check_reward_threshold(task.reward)
    }
}