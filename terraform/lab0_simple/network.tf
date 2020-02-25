// Copyright (c) 2017, 2019, Oracle and/or its affiliates. All rights reserved.

resource "oci_core_virtual_network" vcn1 {
  cidr_block     = "${var.vcn_cidr}"
  compartment_id = "${var.compartment_ocid}"
  display_name   = "${var.vcn_name}"
  dns_label      = "${var.vcn_name}1"
}

resource "oci_core_internet_gateway" "ig1" {
  compartment_id = "${var.compartment_ocid}"
  display_name   = "${var.ig_name}"
  vcn_id         = "${oci_core_virtual_network.vcn1.id}"
}

resource "oci_core_route_table" rt1 {
  compartment_id = "${var.compartment_ocid}"
  vcn_id         = "${oci_core_virtual_network.vcn1.id}"
  display_name   = "${var.route_name}"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = "${oci_core_internet_gateway.ig1.id}"
  }
}

resource "oci_core_subnet" sub1 {
  availability_domain = "${data.oci_identity_availability_domain.ad.name}"
  cidr_block          = "${var.sub_cidr}"
  display_name        = "${var.sub_name}"
  dns_label           = "${var.sub_name}1"
  compartment_id      = "${var.compartment_ocid}"
  vcn_id              = "${oci_core_virtual_network.vcn1.id}"
  route_table_id      = "${oci_core_route_table.rt1.id}"
  dhcp_options_id     = "${oci_core_virtual_network.vcn1.default_dhcp_options_id}"
}