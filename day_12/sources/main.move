/// DAY 12: Option for Task Lookup
/// 
/// Today you will:
/// 1. Learn about Option<T> type
/// 2. Write a function to find tasks by title
/// 3. Handle the case when task is not found
///
/// Note: You can copy code from day_11/sources/solution.move if needed

module challenge::day_12 {

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

    // --- FONKSİYONLAR ---

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

    // GÖREV: Başlığa göre görev bulma
    // Geriye 'Option<u64>' döner. Yani ya bir sayı döner (indeks) ya da 'None' (yok).
    public fun find_task_by_title(board: &TaskBoard, title: &String): Option<u64> {
        let len = vector::length(&board.tasks);
        let mut i = 0;

        // Döngüyle listeyi geziyoruz
        while (i < len) {
            let task = vector::borrow(&board.tasks, i);
            // Eğer başlık eşleşirse:
            if (&task.title == title) {
                // Bulduk! İndeksi 'some' kutusuna koyup döndürüyoruz.
                return option::some(i)
            };
            i = i + 1;
        };

        // Döngü bitti ve bulamadıysak:
        option::none()
    }
}