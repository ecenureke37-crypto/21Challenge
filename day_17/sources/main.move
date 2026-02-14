/// DAY 17: Ownership of Objects & Simple Entry Function
/// 
/// Today you will:
/// 1. Learn about object ownership
/// 2. Write your first entry function
/// 3. Transfer objects to users
///
/// Note: The code includes plotId support. You can copy code from 
/// day_16/sources/solution.move if needed (note: plotId functionality has been added)

module challenge::day_17 {
    use std::vector;
    use sui::object::{Self, UID};
    use sui::tx_context::TxContext;
    // GÖREV 1: Transfer kütüphanesini ekliyoruz
    use sui::transfer;

    // --- SABİTLER ---
    const MAX_PLOTS: u64 = 20;
    const E_PLOT_NOT_FOUND: u64 = 1;
    const E_PLOT_LIMIT_EXCEEDED: u64 = 2;
    const E_INVALID_PLOT_ID: u64 = 3;
    const E_PLOT_ALREADY_EXISTS: u64 = 4;

    // --- STRUCTS ---
    public struct FarmCounters has copy, drop, store {
        planted: u64,
        harvested: u64,
        plots: vector<u8>,
    }

    public struct Farm has key {
        id: UID,
        counters: FarmCounters,
    }

    // --- INTERNAL HELPERS (Gizli İşçiler) ---
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

    // --- LOGIC (Dünkü mantık aynen burada) ---
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

    // PUBLIC FUNCTIONS (Dışarıya Açık Kapılar)

    // GÖREV 2: Çiftliği Yarat ve Paylaş
    // 'entry' kelimesi, bu fonksiyonun cüzdandan doğrudan çağrılabileceğini gösterir.
    public entry fun create_farm(ctx: &mut TxContext) {
        let farm = new_farm(ctx);
        // Çiftliği 'Shared Object' (Paylaşımlı) yapıyoruz.
        // Böylece oyundaki diğer kişiler de bu çiftliği görebilir (şimdilik).
        transfer::share_object(farm);
    }

    // GÖREV 3: Çiftliğe Ekim Yap (Farm objesi üzerinden)
    public fun plant_on_farm(farm: &mut Farm, plot_id: u8) {
        // Asıl işi yapan içerdeki 'plant' fonksiyonuna yönlendiriyoruz
        plant(&mut farm.counters, plot_id);
    }

    // GÖREV 4: Çiftlikten Hasat Et (Farm objesi üzerinden)
    public fun harvest_from_farm(farm: &mut Farm, plot_id: u8) {
        harvest(&mut farm.counters, plot_id);
    }
}