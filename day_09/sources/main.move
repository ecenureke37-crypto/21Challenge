/// DAY 9: Enums & TaskStatus
/// 
/// Today you will:
/// 1. Learn about enums
/// 2. Replace bool with an enum
/// 3. Use match expressions

module challenge::day_09 {
    use std::string::String;

    // GÖREV 1: Durum Listesi (Enum) Oluşturma
    // Artık sadece True/False değil, kendi kelimelerimizi kullanabiliriz.
    public enum TaskStatus has copy, drop {
        Open,      // Görev açık, yapılmayı bekliyor
        Completed, // Görev tamamlandı
    }

    // GÖREV 2: Task Yapısını Güncelleme
    // 'done: bool' yerine artık 'status: TaskStatus' kullanıyoruz.
    public struct Task has copy, drop {
        title: String,
        reward: u64,
        status: TaskStatus, 
    }

    // GÖREV 3: Yeni Görev Oluşturma
    public fun new_task(title: String, reward: u64): Task {
        Task {
            title,
            reward,
            status: TaskStatus::Open, // Varsayılan olarak 'Açık' başlar
        }
    }

    // GÖREV 4: Görev Açık mı Kontrolü
    // Enum'ları '==' işaretiyle karşılaştırabiliriz.
    public fun is_open(task: &Task): bool {
        task.status == TaskStatus::Open
    }
}


