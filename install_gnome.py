import distro


def get_distro(fake_id: str = "") -> tuple[str, str]:
    distro_pretty_name: str = distro.name(pretty=True)
    distro_id = fake_id
    if distro_id == "":
        distro_id = distro.id()
    return (distro_pretty_name, distro_id)


def is_rhel(distro_id: str) -> bool:
    rhel_family = ["fedora", "centos", "rhel", "rocky", "alma"]
    if distro_id in rhel_family:
        return True
    return False


def is_debian(distro_id: str) -> bool:
    debian_family = ["debian", "ubuntu"]
    if distro_id in debian_family:
        return True
    return False


_, distro_id = get_distro()

print(f"is rhel: {is_rhel(distro_id)}")
print(f"is debian: {is_debian(distro_id)}")
