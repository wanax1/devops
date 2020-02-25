// Copyright (c) 2017, 2019, Oracle and/or its affiliates. All rights reserved.
data "oci_identity_availability_domain" "ad" {
  compartment_id = "${var.tenancy_ocid}"
  ad_number      = 1
}

resource "oci_core_instance" inst1 {
  count               = "${var.NumInstances}"
  availability_domain = "${data.oci_identity_availability_domain.ad.name}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "${var.inst_name}${count.index}"
  shape               = "${var.instance_shape}"
 
  create_vnic_details {
    subnet_id        = "${oci_core_subnet.sub1.id}"
    display_name     = "primaryvnic"
    assign_public_ip = true
    hostname_label   = "${var.inst_name}${count.index}"
  }

  source_details {
    source_type = "image"
    source_id   = "${var.instance_image_ocid[var.region]}"
  }
  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
  } 
}
