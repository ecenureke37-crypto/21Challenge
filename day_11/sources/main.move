/// DAY 11: TaskBoard & Address Type
/// 
/// Today you will:
/// 1. Learn about the address type
/// 2. Create a TaskBoard that tracks ownership
/// 3. Understand ownership in practice
///
/// Note: You can copy code from day_10/sources/solution.move if needed
/// 
/// Related: Day 10 (Visibility), Day 12 (Building on TaskBoard)

module challenge::day_11 {
    use std::string::String;

    // --- ENUM ve STRUCTLAR ---

    public enum TaskStatus has copy, drop {
        Open,
        Completed,
    }

    public struct Task has copy, drop {
        title: String,
        reward: u64,
        status: TaskStatus,
    }

    // GÖREV 1: TaskBoard (Görev Panosu) Yapısı
    // Bu pano, kimin olduğunu (owner) ve içindeki görevleri (tasks) tutar.
    public struct TaskBoard has drop {
        owner: address,       // Panonun sahibi (Cüzdan adresi)
        tasks: vector<Task>,  // Görev listesi
    }

    // --- FONKSİYONLAR ---

    public fun new_task(title: String, reward: u64): Task {
        Task {
            title,
            reward,
            status: TaskStatus::Open,
        }
    }

    public fun complete_task(task: &mut Task) {
        task.status = TaskStatus::Completed;
    }

    // GÖREV 2: Yeni Pano Oluşturma
    // Sahip adresini alır, boş bir pano oluşturur.
    public fun new_board(owner: address): TaskBoard {
        TaskBoard {
            owner,
            tasks: vector::empty(),
        }
    }

    // GÖREV 3: Panoya Görev Ekleme
    // Oluşturduğumuz Task'i, Board'un içindeki listeye iter.
    public fun add_task(board: &mut TaskBoard, task: Task) {
        vector::push_back(&mut board.tasks, task);
    }
}