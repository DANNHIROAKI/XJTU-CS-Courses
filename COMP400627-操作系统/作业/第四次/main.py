import random

PAGES = 10
REFERENCE_LENGTH = 20

def generate_reference_string():
    return [random.randint(0, PAGES-1) for _ in range(REFERENCE_LENGTH)]

def fifo(reference, frames):
    page_faults = 0
    current_frames = set()
    order = []

    for ref in reference:
        if ref not in current_frames:
            if len(current_frames) == frames:
                current_frames.remove(order.pop(0))
            current_frames.add(ref)
            order.append(ref)
            page_faults += 1

    return page_faults

def lru(reference, frames):
    page_faults = 0
    current_frames = set()
    indexes = {}

    for i, ref in enumerate(reference):
        if ref not in current_frames:
            if len(current_frames) == frames:
                lru_page = min(indexes, key=indexes.get)
                current_frames.remove(lru_page)
                del indexes[lru_page]
            current_frames.add(ref)
            page_faults += 1
        indexes[ref] = i

    return page_faults

def opt(reference, frames):
    page_faults = 0
    current_frames = set()
    next_use = {}

    for i, ref in enumerate(reference):
        if ref not in current_frames:
            if len(current_frames) == frames:
                farthest_idx = float('-inf')
                replace_page = None
                for page in current_frames:
                    if page not in next_use:
                        replace_page = page
                        break
                    if next_use[page] > farthest_idx:
                        farthest_idx = next_use[page]
                        replace_page = page
                current_frames.remove(replace_page)
            current_frames.add(ref)
            page_faults += 1

        if ref in next_use:
            del next_use[ref]
        for j in range(i+1, len(reference)):
            if reference[j] == ref:
                next_use[ref] = j
                break

    return page_faults

def main():
    reference = generate_reference_string()
    print("Generated Reference String:", ' '.join(map(str, reference)))

    for frames in range(1, 8):
        print(f"\nFor {frames} frames:")
        print("FIFO:", fifo(reference, frames), "page faults.")
        print("LRU :", lru(reference, frames), "page faults.")
        print("OPT :", opt(reference, frames), "page faults.")

if __name__ == "__main__":
    main()
