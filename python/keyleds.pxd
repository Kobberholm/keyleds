# Keyleds -- Gaming keyboard tool
# Copyright (C) 2017 Julien Hartmann, juli1.hartmann@gmail.com
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

cdef extern from "keyleds.h":
    ctypedef unsigned int uint8_t
    ctypedef unsigned int uint16_t
    ctypedef struct Keyleds:
        pass

    ctypedef enum keyleds_device_handler_t:
        pass

    cdef struct keyleds_device_version_protocol:
        uint8_t     type
        char        prefix[4]
        unsigned    version_major
        unsigned    version_minor
        unsigned    build
        bint        is_active
        uint16_t    product_id

    cdef struct keyleds_device_version:
        uint8_t     serial[4]
        uint16_t    transport
        uint8_t     model[6]
        unsigned    length
        keyleds_device_version_protocol protocols[0]

    ctypedef enum keyleds_device_type_t:
        pass

    Keyleds * keyleds_open(const char * path, uint8_t app_id)
    void keyleds_close(Keyleds * device)
    int keyleds_device_fd(Keyleds * device)

    bint keyleds_get_protocol(Keyleds * device, uint8_t target_id,
                              unsigned * version, keyleds_device_handler_t * handler)
    bint keyleds_ping(Keyleds * device, uint8_t target_id)
    unsigned keyleds_get_feature_count(Keyleds * dev, uint8_t target_id)
    uint16_t keyleds_get_feature_id(Keyleds * dev, uint8_t target_id, uint8_t feature_idx)

    bint keyleds_get_device_name(Keyleds * device, uint8_t target_id, char ** out)
    bint keyleds_get_device_type(Keyleds * device, uint8_t target_id,
                                 keyleds_device_type_t * out)
    bint keyleds_get_device_version(Keyleds * device, uint8_t target_id,
                                    keyleds_device_version ** out)

    bint keyleds_gamemode_max(Keyleds * device, uint8_t target_id, unsigned * nb)
    bint keyleds_gamemode_set(Keyleds * device, uint8_t target_id,
                              const uint8_t * ids, unsigned ids_nb)
    bint keyleds_gamemode_clear(Keyleds * device, uint8_t target_id,
                              const uint8_t * ids, unsigned ids_nb)
    bint keyleds_gamemode_reset(Keyleds * device, uint8_t target_id)


    ctypedef enum keyleds_keyboard_layout_t:
        KEYLEDS_KEYBOARD_LAYOUT_INVALID

    keyleds_keyboard_layout_t keyleds_keyboard_layout(Keyleds * device, uint8_t target_id)

    bint keyleds_get_reportrates(Keyleds * device, uint8_t target_id, unsigned ** out)
    bint keyleds_get_reportrate(Keyleds * device, uint8_t target_id, unsigned * rate)
    bint keyleds_set_reportrate(Keyleds * device, uint8_t target_id, unsigned rate)

    ctypedef enum keyleds_block_id_t:
        pass

    cdef struct keyleds_keyblocks_info_block:
        keyleds_block_id_t  block_id
        uint16_t            nb_keys
        uint8_t             red
        uint8_t             green
        uint8_t             blue

    cdef struct keyleds_keyblocks_info:
        unsigned            length
        keyleds_keyblocks_info_block blocks[0]

    cdef struct keyleds_key_color:
        uint8_t         id
        uint8_t         red
        uint8_t         green
        uint8_t         blue

    bint keyleds_get_block_info(Keyleds * device, uint8_t target_id,
                                keyleds_keyblocks_info ** out)
    void keyleds_free_block_info(keyleds_keyblocks_info * info)
    bint keyleds_get_leds(Keyleds * device, uint8_t target_id, keyleds_block_id_t block_id,
                          keyleds_key_color * keys, uint16_t offset, unsigned keys_nb)
    bint keyleds_set_leds(Keyleds * device, uint8_t target_id, keyleds_block_id_t block_id,
                          keyleds_key_color * keys, unsigned keys_nb)
    bint keyleds_set_led_block(Keyleds * device, uint8_t target_id, keyleds_block_id_t block_id,
                               uint8_t red, uint8_t green, uint8_t blue)
    bint keyleds_commit_leds(Keyleds * device, uint8_t target_id)

    const char * keyleds_get_error_str()

    cdef struct keyleds_indexed_string:
        pass

    extern const keyleds_indexed_string keyleds_feature_names[0]
    extern const keyleds_indexed_string keyleds_protocol_types[0]
    extern const keyleds_indexed_string keyleds_device_types[0]
    extern const keyleds_indexed_string keyleds_block_id_names[0]
    extern const keyleds_indexed_string keyleds_keycode_names[0]

    const char * keyleds_lookup_string(const keyleds_indexed_string *, unsigned id)
    unsigned keyleds_string_id(const keyleds_indexed_string *, const char * str)

    unsigned keyleds_translate_scancode(keyleds_block_id_t block, uint8_t scancode)
    bint keyleds_translate_keycode(unsigned keycode, keyleds_block_id_t * block, uint8_t * scancode)
