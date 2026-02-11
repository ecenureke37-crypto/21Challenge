/// DAY 14: Tests for Bounty Board
/// 
/// Today you will:
/// 1. Write comprehensive tests
/// 2. Test all the functions you've created
/// 3. Practice test organization
///
/// Note: You can copy code from day_13/sources/solution.move if needed
module challenge::day_14 {
    use std::string::{Self, String};
    
    // Testlerde işimize yarayacak yardımcı kütüphaneler
    #[test_only]

    // --- YAPILAR

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

    // FONKSİYONLAR

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

    public fun total_reward(board: &TaskBoard): u64 {
        let len = vector::length(&board.tasks);
        let mut total = 0;
        let mut i = 0;
        while (i < len) {
            let task = vector::borrow(&board.tasks, i);
            total = total + task.reward;
            i = i + 1;
        };
        total
    }

    public fun completed_count(board: &TaskBoard): u64 {
        let len = vector::length(&board.tasks);
        let mut count = 0;
        let mut i = 0;
        while (i < len) {
            let task = vector::borrow(&board.tasks, i);
            if (task.status == TaskStatus::Completed) {
                count = count + 1;
            };
            i = i + 1;
        };
        count
    }

    //  TESTLER (HAFTANIN FİNALİ)

    // TEST 1: Pano oluşturma ve görev ekleme
    #[test]
    fun test_create_board_and_add_task() {
        // Sahte bir kullanıcı adresi uyduralım (@0x1)
        let owner = @0x1;
        let mut board = new_board(owner);
        
        let task = new_task(string::utf8(b"Move Ogren"), 100);
        add_task(&mut board, task);

        // Listenin uzunluğu 1 olmalı
        assert!(vector::length(&board.tasks) == 1, 0);
    }

    // TEST 2: Görev tamamlama ve sayma
    #[test]
    fun test_complete_task() {
        let owner = @0x2;
        let mut board = new_board(owner);
        
        // Görevi ekle
        let task = new_task(string::utf8(b"Kod Yaz"), 50);
        add_task(&mut board, task);

        // Listeden görevi al ve tamamla
        // (Not: Listeden değiştirmek için 'borrow_mut' kullanıyoruz)
        let task_ref = vector::borrow_mut(&mut board.tasks, 0);
        complete_task(task_ref);

        // Tamamlanan görev sayısı 1 olmalı
        assert!(completed_count(&board) == 1, 1);
    }

    // TEST 3: Toplam ödül hesabı
    #[test]
    fun test_total_reward() {
        let owner = @0x3;
        let mut board = new_board(owner);

        // İki farklı görev ekleyelim: 100 + 50 puan
        add_task(&mut board, new_task(string::utf8(b"Gorev 1"), 100));
        add_task(&mut board, new_task(string::utf8(b"Gorev 2"), 50));

        // Toplam 150 olmalı
        assert!(total_reward(&board) == 150, 2);
    }
}