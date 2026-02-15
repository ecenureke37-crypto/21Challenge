/// DAY 18: Receiving Objects & Updating State
/// 
/// Today you will:
/// 1. Write entry functions that receive objects
/// 2. Update object state on-chain
/// 3. Understand how objects are passed in transactions
///
/// Note: The code includes plotId support. You can copy code from 
/// day_17/sources/solution.move if needed (note: plotId functionality has been added)

module challenge::day_18 {
    use std::vector;
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::TxContext;

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

    // INTERNAL HELPERS
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

    //  LOGIC (İş Mantığı)
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

    //  INTERNAL WRAPPERS 
    fun plant_on_farm(farm: &mut Farm, plot_id: u8) {
        plant(&mut farm.counters, plot_id);
    }

    fun harvest_from_farm(farm: &mut Farm, plot_id: u8) {
        harvest(&mut farm.counters, plot_id);
    }

    // ENTRY FUNCTIONS (Halka Açık Kapılar)
    
    // Çiftliği oluşturur ve paylaşır
    public entry fun create_farm(ctx: &mut TxContext) {
        let farm = new_farm(ctx);
        transfer::share_object(farm);
    }

    // GÖREV 1: Ekim Yapma Giriş Fonksiyonu
    // Kullanıcı cüzdanından bu fonksiyonu çağırır.
    // Sui sistemi, paylaşılan 'Farm' objesini bulur ve buraya '&mut' olarak gönderir.
    public entry fun plant_on_farm_entry(farm: &mut Farm, plot_id: u8) {
        plant_on_farm(farm, plot_id);
    }

    // GÖREV 2: Hasat Etme Giriş Fonksiyonu
    public entry fun harvest_from_farm_entry(farm: &mut Farm, plot_id: u8) {
        harvest_from_farm(farm, plot_id);
    }
}
