/// DAY 13: Simple Aggregations (Total Reward, Completed Count)
/// 
/// Today you will:
/// 1. Write functions that iterate over vectors
/// 2. Calculate totals and counts
/// 3. Practice with control flow
///
/// Note: You can copy code from day_12/sources/solution.move if needed

module challenge::day_13 {
    use std::string::String;

    // --- YAPILAR ---
    public enum TaskStatus has copy, drop {
        Open,
        Completed,
    }

    public struct Task has copy, drop {
        title: String,
        reward: u64,
        status: TaskStatus,
    }

    public struct TaskBoard has drop {
        owner: address,
        tasks: vector<Task>,
    }

    // --- MEVCUT FONKSİYONLAR ---

    public fun new_task(title: String, reward: u64): Task {
        Task {
            title,
            reward,
            status: TaskStatus::Open,
        }
    }

    public fun new_board(owner: address): TaskBoard {
        TaskBoard {
            owner,
            tasks: vector::empty(),
        }
    }

    public fun add_task(board: &mut TaskBoard, task: Task) {
        vector::push_back(&mut board.tasks, task);
    }

    public fun complete_task(task: &mut Task) {
        task.status = TaskStatus::Completed;
    }

    public fun find_task_by_title(board: &TaskBoard, title: &String): Option<u64> {
        let len = vector::length(&board.tasks);
        let mut i = 0;
        while (i < len) {
            let task = vector::borrow(&board.tasks, i);
            if (&task.title == title) {
                return option::some(i)
            };
            i = i + 1;
        };
        option::none()
    }

    // --- GÖREV 1: Toplam Ödül Hesabı ---
    public fun total_reward(board: &TaskBoard): u64 {
        let len = vector::length(&board.tasks);
        let mut i = 0;
        let mut total = 0; // Toplamı tutacağımız sepet

        while (i < len) {
            let task = vector::borrow(&board.tasks, i);
            // Sepete o anki görevin ödülünü ekle
            total = total + task.reward;
            i = i + 1;
        };
        total
    }

    // --- GÖREV 2: Tamamlanan Görev Sayısı ---
    public fun completed_count(board: &TaskBoard): u64 {
        let len = vector::length(&board.tasks);
        let mut i = 0;
        let mut count = 0; // Sayacı sıfırdan başlat

        while (i < len) {
            let task = vector::borrow(&board.tasks, i);
            // Sadece görevin durumu 'Completed' ise sayacı artır
            if (task.status == TaskStatus::Completed) {
                count = count + 1;
            };
            i = i + 1;
        };
        count
    }
}