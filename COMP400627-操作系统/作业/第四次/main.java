import java.util.*;

public class PageReplacement {

    private static final int PAGES = 10;
    private static final int REFERENCE_LENGTH = 20;

    private static List<Integer> generateReferenceString() {
        List<Integer> reference = new ArrayList<>();
        Random rand = new Random();

        for (int i = 0; i < REFERENCE_LENGTH; i++) {
            reference.add(rand.nextInt(PAGES));
        }

        return reference;
    }

    private static int fifo(List<Integer> reference, int frames) {
        int pageFaults = 0;
        Set<Integer> currentFrames = new HashSet<>();
        Queue<Integer> order = new LinkedList<>();

        for (int ref : reference) {
            if (!currentFrames.contains(ref)) {
                if (currentFrames.size() == frames) {
                    int firstIn = order.poll();
                    currentFrames.remove(firstIn);
                }
                currentFrames.add(ref);
                order.offer(ref);
                pageFaults++;
            }
        }

        return pageFaults;
    }

    private static int lru(List<Integer> reference, int frames) {
        int pageFaults = 0;
        Set<Integer> currentFrames = new HashSet<>();
        Map<Integer, Integer> indexes = new HashMap<>();

        for (int i = 0; i < reference.size(); i++) {
            int ref = reference.get(i);
            if (!currentFrames.contains(ref)) {
                if (currentFrames.size() == frames) {
                    int lruPage = -1, lruIdx = Integer.MAX_VALUE;
                    for (int page : currentFrames) {
                        if (indexes.get(page) < lruIdx) {
                            lruIdx = indexes.get(page);
                            lruPage = page;
                        }
                    }
                    currentFrames.remove(lruPage);
                }
                currentFrames.add(ref);
                pageFaults++;
            }
            indexes.put(ref, i);
        }

        return pageFaults;
    }

    private static int opt(List<Integer> reference, int frames) {
        int pageFaults = 0;
        Set<Integer> currentFrames = new HashSet<>();
        Map<Integer, Integer> nextUse = new HashMap<>();

        for (int i = 0; i < reference.size(); i++) {
            int ref = reference.get(i);
            if (!currentFrames.contains(ref)) {
                if (currentFrames.size() == frames) {
                    int farthestIdx = -1, replacePage = -1;
                    for (int page : currentFrames) {
                        if (!nextUse.containsKey(page)) {
                            replacePage = page;
                            break;
                        } else if (nextUse.get(page) > farthestIdx) {
                            farthestIdx = nextUse.get(page);
                            replacePage = page;
                        }
                    }
                    currentFrames.remove(replacePage);
                }
                currentFrames.add(ref);
                pageFaults++;
            }
            nextUse.remove(ref);
            for (int j = i + 1; j < reference.size(); j++) {
                if (reference.get(j).equals(ref)) {
                    nextUse.put(ref, j);
                    break;
                }
            }
        }

        return pageFaults;
    }

    public static void main(String[] args) {
        List<Integer> reference = generateReferenceString();
        System.out.print("Generated Reference String: ");
        for (int r : reference) {
            System.out.print(r + " ");
        }
        System.out.println();

        for (int frames = 1; frames <= 7; frames++) {
            System.out.println("\nFor " + frames + " frames:");
            System.out.println("FIFO: " + fifo(reference, frames) + " page faults.");
            System.out.println("LRU : " + lru(reference, frames) + " page faults.");
            System.out.println("OPT : " + opt(reference, frames) + " page faults.");
        }
    }
}
