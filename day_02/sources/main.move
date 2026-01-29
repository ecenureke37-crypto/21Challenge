/// DAY 2: Primitive Types & Simple Functions
/// 
/// Today you will:
/// 1. Practice with primitive types (u64, bool)
/// 2. Write your first function
/// 3. Write your first test

module challenge::day_02 {
    #[test_only]
    use std::unit_test::assert_eq;

    // Görev 1: İki u64 sayısını toplayan 'sum' fonksiyonu
    public fun sum(a: u64, b: u64): u64 {
        a + b
    }

    // Görev 2: sum(1, 2)'nin 3'e eşit olduğunu kontrol eden test
    #[test]
    fun test_sum() {
        let sonuc = sum(1, 2);
        assert_eq!(sonuc, 3); 
    }
}
