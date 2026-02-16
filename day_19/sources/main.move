/// DAY 19: Simple Query Functions (View-like)
/// 
/// Today you will:
/// 1. Write read-only functions
/// 2. Query object state
/// 3. Write tests for query functions (optional)
///
/// Note: The code includes plotId support with all farm functions. 
/// You can reference day_18/sources/solution.move for basic structure, 


module challenge::day_19 {
    use std::vector;
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};

    // SABİTLER
    const MAX_PLOTS: u64 = 20;
    const E_PLOT_NOT_FOUND: u64 = 1;
    const E_PLOT_LIMIT_EXCEEDED: u64 = 2;
    const E_INVALID_PLOT_ID: u64 = 3;
    const E_PLOT_ALREADY_EXISTS: u64 = 4;

    // STRUCTS
    public struct FarmCounters has copy, drop, store {
        planted: u64,
        harvested: u64,
        plots: vector<u8>,
    }

    public struct Farm has key {
        id: UID,
        counters: FarmCounters,
    }

    // HELPERS
    fun new_counters(): FarmCounters {
        FarmCounters {
            planted: 0,
            harvested: 0,
            plots: vector::empty(),
        }
    }

    fun new_farm(ctx: &mut TxContext): Farm {
        Farm {
            id: object::new(ctx),
            counters: new_counters(),
        }
    }

    // LOGIC
    fun plant(counters: &mut FarmCounters, plot_id: u8) {
        assert!(plot_id >= 1 && plot_id <= (MAX_PLOTS as u8), E_INVALID_PLOT_ID);
        let len = vector::length(&counters.plots);
        assert!(len < MAX_PLOTS, E_PLOT_LIMIT_EXCEEDED);
        
        let mut i = 0;
        while (i < len) {
            let existing_plot = vector::borrow(&counters.plots, i);
            assert!(*existing_plot != plot_id, E_PLOT_ALREADY_EXISTS);
            i = i + 1;
        };
        
        counters.planted = counters.planted + 1;
        vector::push_back(&mut counters.plots, plot_id);
    }

    fun harvest(counters: &mut FarmCounters, plot_id: u8) {
        let len = vector::length(&counters.plots);
        let mut i = 0;
        let mut found_index = len; 
        while (i < len) {
            let existing_plot = vector::borrow(&counters.plots, i);
            if (*existing_plot == plot_id) {
                found_index = i;
            };
            i = i + 1;
        };
        
        assert!(found_index < len, E_PLOT_NOT_FOUND);
        
        vector::remove(&mut counters.plots, found_index);
        counters.harvested = counters.harvested + 1;
    }

    // ENTRY FUNCTIONS
    public entry fun create_farm(ctx: &mut TxContext) {
        let farm = new_farm(ctx);
        transfer::share_object(farm);
    }

    public entry fun plant_on_farm(farm: &mut Farm, plot_id: u8) {
        plant(&mut farm.counters, plot_id);
    }

    public entry fun harvest_from_farm(farm: &mut Farm, plot_id: u8) {
        harvest(&mut farm.counters, plot_id);
    }

    // GÖREV: VIEW FUNCTIONS (Sorgu Fonksiyonları)
    
    // GÖREV 1: Toplam Ekilen Sayısını Getir
    // Not: &Farm kullanıyoruz, çünkü veri değiştirmeyeceğiz.
    public fun total_planted(farm: &Farm): u64 {
        farm.counters.planted
    }

    // GÖREV 2: Toplam Hasat Sayısını Getir
    public fun total_harvested(farm: &Farm): u64 {
        farm.counters.harvested
    }

    // TEST (İsteğe Bağlı)
    #[test]
    fun test_stats() {
        // Dummy bir context oluşturup test edelim
        let mut ctx = tx_context::dummy();
        
        // 1. Çiftliği yarat
        let mut farm = new_farm(&mut ctx);

        // 2. İki kez ekim yap
        plant_on_farm(&mut farm, 1);
        plant_on_farm(&mut farm, 5);

        // 3. İstatistikleri kontrol et (2 ekim, 0 hasat)
        assert!(total_planted(&farm) == 2, 0);
        assert!(total_harvested(&farm) == 0, 1);

        // 4. Birini hasat et
        harvest_from_farm(&mut farm, 1);

        // 5. Sonuç: Ekilen sayısı hala 2 (tarihçe), Hasat 1
        assert!(total_planted(&farm) == 2, 2);
        assert!(total_harvested(&farm) == 1, 3);

        // Temizlik (Test objesini yok et)
        let Farm { id, counters: _ } = farm;
        object::delete(id);
    }
}