#!/bin/bash
set -e

# ===============================
# Проверка sudo (без root-логина)
# ===============================
if ! sudo -v; then
  echo "Ошибка: нет прав sudo"
  exit 1
fi

# ===============================
# Генерация gateway_ID
# 16 символов: A-Z0-9
# ===============================
GATEWAY_ID=$(tr -dc 'A-Z0-9' </dev/urandom | head -c 16)

echo "Сгенерирован gateway_ID: $GATEWAY_ID"

# ===============================
# Пути
# ===============================
CONF_DIR="/etc/LoRa"
CONF_FILE="$CONF_DIR/global_conf.json"

# ===============================
# Создание директории
# ===============================
sudo mkdir -p "$CONF_DIR"

# ===============================
# Создание конфига
# ===============================
sudo tee "$CONF_FILE" > /dev/null <<EOF
{
  "SX130x_conf": {
    "com_type": "SPI",
    "com_path": "/dev/spidev0.0",
    "lorawan_public": true,
    "clksrc": 0,
    "antenna_gain": 0,
    "full_duplex": false,
        "fine_timestamp": {
        "enable": true,
        "mode": "all_sf"
    },
    "radio_0": {
      "enable": true,
      "type": "SX1250",
      "freq": 864500000,
      "rssi_offset": -215.4,
      "rssi_tcomp": {
        "coeff_a": 0,
        "coeff_b": 0,
        "coeff_c": 20.41,
        "coeff_d": 2162.56,
        "coeff_e": 0
      },
      "tx_enable": true,
      "tx_freq_min": 863000000,
      "tx_freq_max": 870000000,
      "tx_gain_lut": [
        {
          "rf_power": 12,
          "pa_gain": 0,
          "pwr_idx": 15
        },
        {
          "rf_power": 13,
          "pa_gain": 0,
          "pwr_idx": 16
        },
        {
          "rf_power": 14,
          "pa_gain": 0,
          "pwr_idx": 17
        },
        {
          "rf_power": 15,
          "pa_gain": 0,
          "pwr_idx": 19
        },
        {
          "rf_power": 16,
          "pa_gain": 0,
          "pwr_idx": 20
        },
        {
          "rf_power": 17,
          "pa_gain": 0,
          "pwr_idx": 22
        },
        {
          "rf_power": 18,
          "pa_gain": 1,
          "pwr_idx": 1
        },
        {
          "rf_power": 19,
          "pa_gain": 1,
          "pwr_idx": 2
        },
        {
          "rf_power": 20,
          "pa_gain": 1,
          "pwr_idx": 3
        },
        {
          "rf_power": 21,
          "pa_gain": 1,
          "pwr_idx": 4
        },
        {
          "rf_power": 22,
          "pa_gain": 1,
          "pwr_idx": 5
        },
        {
          "rf_power": 23,
          "pa_gain": 1,
          "pwr_idx": 6
        },
        {
          "rf_power": 24,
          "pa_gain": 1,
          "pwr_idx": 7
        },
        {
          "rf_power": 25,
          "pa_gain": 1,
          "pwr_idx": 9
        },
        {
          "rf_power": 26,
          "pa_gain": 1,
          "pwr_idx": 11
        },
        {
          "rf_power": 27,
          "pa_gain": 1,
          "pwr_idx": 14
        }
      ]
    },
    "radio_1": {
      "enable": true,
      "type": "SX1250",
      "freq": 869000000,
      "rssi_offset": -215.4,
      "rssi_tcomp": {
        "coeff_a": 0,
        "coeff_b": 0,
        "coeff_c": 20.41,
        "coeff_d": 2162.56,
        "coeff_e": 0
      },
      "tx_enable": false
    },
    "chan_multiSF_All": {
      "spreading_factor_enable": [
        5,
        6,
        7,
        8,
        9,
        10,
        11,
        12
      ]
    },
    "chan_multiSF_0": {
      "enable": true,
      "radio": 0,
      "if": -400000
    },
    "chan_multiSF_1": {
      "enable": true,
      "radio": 0,
      "if": -200000
    },
    "chan_multiSF_2": {
      "enable": true,
      "radio": 0,
      "if": 0
    },
    "chan_multiSF_3": {
      "enable": true,
      "radio": 0,
      "if": 200000
    },
    "chan_multiSF_4": {
      "enable": true,
      "radio": 0,
      "if": 400000
    },
    "chan_multiSF_5": {
      "enable": true,
      "radio": 1,
      "if": -100000
    },
    "chan_multiSF_6": {
      "enable": true,
      "radio": 1,
      "if": 100000
    },
    "chan_multiSF_7": {
      "enable": false,
      "radio": 0,
      "if": 400000
    },
    "chan_Lora_std": {
      "enable": false,
      "radio": 1,
      "if": -200000,
      "bandwidth": 250000,
      "spread_factor": 7,
      "implicit_hdr": false,
      "implicit_payload_length": 17,
      "implicit_crc_en": false,
      "implicit_coderate": 1
    },
    "chan_FSK": {
      "enable": false,
      "radio": 1,
      "if": 300000,
      "bandwidth": 125000,
      "datarate": 50000
    }
  },
  "gateway_conf": {
    "gateway_ID": "$GATEWAY_ID",
    "server_address": "10.10.1.65",
    "serv_port_up": 1700,
    "serv_port_down": 1700,
    "keepalive_interval": 10,
    "autoquit_threshold": 10,
    "stat_interval": 30,
    "push_timeout_ms": 100,
    "forward_crc_valid": true,
    "forward_crc_error": false,
    "forward_crc_disabled": false,
    "gps_tty_path": "/dev/ttymxc2",
    "gps_active_script":"echo default-on >/sys/class/leds/led-gps/trigger",
    "gps_passive_script":"echo heartbeat >/sys/class/leds/led-gps/trigger",
    "ref_latitude": 0,
    "ref_longitude": 0,
    "ref_altitude": 0,
    "fake_gps": false
  },
  "debug_conf": {
    "ref_payload": [
      {
        "id": "0xCAFE1234"
      },
      {
        "id": "0xCAFE2345"
      }
    ]
  }
}
EOF

# ===============================
# Перезапуск сервиса
# ===============================
sudo systemctl restart lora_pkt_fwd

# ===============================
# Проверка статуса
# ===============================
if systemctl is-active --quiet lora_pkt_fwd; then
  echo "Служба lora_pkt_fwd успешно запущена"
else
  echo "Ошибка: lora_pkt_fwd не запустилась"
  exit 1
fi

echo "Готово."
