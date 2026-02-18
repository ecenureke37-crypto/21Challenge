/// DAY 21: Final Tests & Cleanup
/// 
/// Today you will:
/// 1. Write comprehensive tests for the farm
/// 2. Clean up your code
/// 3. Review what you've learned
///
/// Note: You can copy code from day_20/sources/solution.move if needed
module challenge::day_21 {
    use std::vector;
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use sui::event;

    // Test için gerekli kütüphane
    #[test_only]
    use sui::test_scenario;

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

    public struct PlantEvent has copy, drop {
        planted_after: u64,
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

    //LOGIC
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

    // VIEW FUNCTIONS
    public fun total_planted(farm: &Farm): u64 {
        farm.counters.planted
    }

    public fun total_harvested(farm: &Farm): u64 {
        farm.counters.harvested
    }

    //ENTRY FUNCTIONS
    public entry fun create_farm(ctx: &mut TxContext) {
        let farm = new_farm(ctx);
        transfer::share_object(farm);
    }

    public entry fun plant_on_farm_entry(farm: &mut Farm, plot_id: u8) {
        plant(&mut farm.counters, plot_id);
        let current_total = total_planted(farm);
        event::emit(PlantEvent {
            planted_after: current_total
        });
    }

    public entry fun harvest_from_farm_entry(farm: &mut Farm, plot_id: u8) {
        harvest(&mut farm.counters, plot_id);
    }
    // 🧪 GRAND FINALE TESTS 🧪
    

    #[test]
    fun test_create_farm() {
        let admin = @0xA;
        let mut scenario = test_scenario::begin(admin);
        
        // 1. Çiftliği kur
        create_farm(test_scenario::ctx(&mut scenario));
        test_scenario::next_tx(&mut scenario, admin);

        // 2. Paylaşılan objeyi al ve kontrol et
        {
            let farm = test_scenario::take_shared<Farm>(&scenario);
            assert!(total_planted(&farm) == 0, 0);
            assert!(total_harvested(&farm) == 0, 0);
            test_scenario::return_shared(farm);
        };
        test_scenario::end(scenario);
    }

    #[test]
    fun test_planting_increases_counter() {
        let user = @0xB;
        let mut scenario = test_scenario::begin(user);
        
        create_farm(test_scenario::ctx(&mut scenario));
        test_scenario::next_tx(&mut scenario, user);

        {
            let mut farm = test_scenario::take_shared<Farm>(&scenario);
            plant_on_farm_entry(&mut farm, 1); // 1 numaralı tarlaya ek
            assert!(total_planted(&farm) == 1, 1);
            test_scenario::return_shared(farm);
        };
        test_scenario::end(scenario);
    }

    #[test]
    fun test_harvesting_increases_counter() {
        let user = @0xC;
        let mut scenario = test_scenario::begin(user);
        create_farm(test_scenario::ctx(&mut scenario));
        test_scenario::next_tx(&mut scenario, user);

        {
            let mut farm = test_scenario::take_shared<Farm>(&scenario);
            plant_on_farm_entry(&mut farm, 1);
            harvest_from_farm_entry(&mut farm, 1);
            
            // Ekilen sayısı (tarihçe) hala 1 olmalı, hasat edilen 1 olmalı
            assert!(total_planted(&farm) == 1, 1);
            assert!(total_harvested(&farm) == 1, 2);
            test_scenario::return_shared(farm);
        };
        test_scenario::end(scenario);
    }

    #[test]
    #[expected_failure(abort_code = E_INVALID_PLOT_ID)]
    fun test_invalid_plot_id() {
        let user = @0xD;
        let mut scenario = test_scenario::begin(user);
        create_farm(test_scenario::ctx(&mut scenario));
        test_scenario::next_tx(&mut scenario, user);

        {
            let mut farm = test_scenario::take_shared<Farm>(&scenario);
            // 25 numaralı tarla yok (max 20), hata vermeli!
            plant_on_farm_entry(&mut farm, 25);
            test_scenario::return_shared(farm);
        };
        test_scenario::end(scenario);
    }

    #[test]
    #[expected_failure(abort_code = E_PLOT_ALREADY_EXISTS)]
    fun test_duplicate_plot() {
        let user = @0xE;
        let mut scenario = test_scenario::begin(user);
        create_farm(test_scenario::ctx(&mut scenario));
        test_scenario::next_tx(&mut scenario, user);

        {
            let mut farm = test_scenario::take_shared<Farm>(&scenario);
            plant_on_farm_entry(&mut farm, 5);
            // Aynı tarlaya tekrar ekmeye çalışıyoruz, hata vermeli!
            plant_on_farm_entry(&mut farm, 5);
            test_scenario::return_shared(farm);
        };
        test_scenario::end(scenario);
    }

    #[test]
    #[expected_failure(abort_code = E_PLOT_NOT_FOUND)]
    fun test_harvest_nonexistent_plot() {
        let user = @0xF;
        let mut scenario = test_scenario::begin(user);
        create_farm(test_scenario::ctx(&mut scenario));
        test_scenario::next_tx(&mut scenario, user);

        {
            let mut farm = test_scenario::take_shared<Farm>(&scenario);
            // Hiç ekilmemiş tarlayı (10) hasat etmeye çalışıyoruz
            harvest_from_farm_entry(&mut farm, 10);
            test_scenario::return_shared(farm);
        };
        test_scenario::end(scenario);
    }
}